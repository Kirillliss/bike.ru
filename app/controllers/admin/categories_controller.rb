class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @products = Product.frontpageable
  end

  # GET /categories/1
  # GET /categories/1.json
  def show

  end

  def sort
    records = params[:category].inject({}) do |res, (resource, parent_resource)|
      res[Category.find(resource)] = Category.find(parent_resource) rescue nil
      res
    end
    errors = []
    ActiveRecord::Base.transaction do
      records.each_with_index do |(record, parent_record), position|
        record.send "position=", position
        record.send "parent=", parent_record
        errors << {record.id => record.errors} if !record.save
      end
    end
    if errors.empty?
      head 200
    else
      render json: errors, status: 422
    end
    # params[:category].sort { |a, b| a <=> b }.each_with_index do |id, index|
    #   value = id[1][:id]
    #   position = id[1][:position]
    #   position = position.to_i + 1
    #   parent = id[1][:parent_id]
    #   parent = nil if parent == 'null'
    #   logger.debug { "\nupdating_categorys with parent=#{parent} value=#{value} position=#{position}\n\n" }
    #   Category.update(value, :position => position, :parent_id => parent)
    # end
  end

  # GET /categories/new
  def new
    @category = Category.new

    if Project.count == 1
      @category.project_ids = Project.first.id
    end

  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to [:admin, @category], notice: 'category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to [:admin, @category], notice: 'category was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @category }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to admin_categories_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:title, :seo_title, :topper, :seo_keywords, :seo_description, :published, :image, :discount_id, project_ids: [] )
    end
end
