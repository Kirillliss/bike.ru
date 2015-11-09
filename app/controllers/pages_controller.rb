class PagesController < BaseController
  def show
    @page = Page.find(params[:id])
    @products = current_project.products.frontpageable.page params[:page]
    @best_seller = @products.first
  end
end
