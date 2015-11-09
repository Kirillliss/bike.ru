class Admin::ProductsController < Admin::BaseController
  before_action :set_category, except: [:index]
  before_action :set_product, only: [:show, :edit, :destroy, :update]
  def show
  end

  def edit
  end

  def new
    @product = @category.products.new
  end

  def index
    @products = Product.all
  end

  # POST /categories
  # POST /categories.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to [:admin, @product.category, @product], notice: 'category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to [:admin, @product.category, @product], notice: 'category was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @product }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @category] }
      format.json { head :no_content }
    end
  end

  private
    def set_category
      @category = Category.find(params[:category_id]) if params[:category_id]
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :seo_title, :benefit, :hit, :markdown, :seo_keywords, :seo_description, :old_price, :price, :article, :description, :published, :frontpageable, :category_id, :discount_id, images_attributes: [:id, :image, :_destroy])
    end
end
