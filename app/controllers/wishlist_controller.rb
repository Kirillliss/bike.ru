class WishlistController < BaseController
  def index
    # ids = session[:wishlist_ids]
    @products = Product.find(session[:wishlist_ids]) if session[:wishlist_ids]
    if @products.nil? || @products.count == 0
      redirect_to root_path, notice: "Нет товаров для сравнения"
    end
  end

  def add_to_wishlist
    session[:wishlist_ids] ||= []
    session[:wishlist_ids] << params[:id] unless session[:wishlist_ids].include? params[:id]
    redirect_to :back
  end

  def destroy
    @product_id = params[:id]
    session[:wishlist_ids].delete(@product_id)
    respond_to do |format|
      format.js
    end
  end

end
