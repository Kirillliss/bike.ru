class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /admin/pages
  # GET /admin/pages.json
  def index
    @pages = Page.all
  end

  # GET /admin/pages/1
  # GET /admin/pages/1.json
  def show
  end

  # GET /admin/pages/new
  def new
    @page = Page.new
  end

  def sort
    records = params[:page].inject({}) do |res, (resource, parent_resource)|
      res[Page.find(resource)] = Page.find(parent_resource) rescue nil
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
  end

  # GET /admin/pages/1/edit
  def edit
  end

  # POST /admin/pages
  # POST /admin/pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to [:admin, @page], notice: 'Page was successfully created.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/pages/1
  # PATCH/PUT /admin/pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to [:admin, @page], notice: 'Page was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @page }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/pages/1
  # DELETE /admin/pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to admin_pages_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :seo_title, :seo_keywords, :seo_description, :body, :published, :everywhereable, project_ids: [])
    end
end
