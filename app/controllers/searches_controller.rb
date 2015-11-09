class SearchesController < BaseController

  def show
    @products = Product.filter_title(search_params[:product_title]).page(params[:page])
    @search = Search.new(price_from: Product.min_price.price.to_i, price_to: Product.max_price.price.to_i)
  end

  def search_params
    params.require(:search).permit(:product_title)
  end

end
