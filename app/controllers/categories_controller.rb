class CategoriesController < BaseController

  before_action :set_category_show, only: [:show]
  before_action :set_category_search, only: [:search]

  before_action :get_products, only: [:show, :search]

  def index
    @categories = Category.all
  end

  def show
    #создаем новый поиск
    @search = Search.new(price_from: Product.min_price.price.to_i, price_to: Product.max_price.price.to_i, category_id: @category.id)
  end

  def search
    #делаем отбор по параметрам поиска:
    @products = @search.filter_products @products
    render 'show'
  end

  def set_category_show
    @category = Category.find(params[:id])
  end

  def set_category_search
    #получаем параметры поиска
    @search = Search.new(search_params)
    #получаем категорию для которйо идет поиск
    @category = Category.find(@search.category.id)
  end

  def get_products
    @products = @category.child_products.aviable.page params[:page]
    if params[:all]
      @products = @products.per(@category.child_products.aviable.count)
    end
    @best_seller = @products.first
  end

  def search_params
    params.require(:search).permit(:price_from, :price_to, :producer_id, :category_id)
  end

end
