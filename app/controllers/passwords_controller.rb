class PasswordsController < Devise::PasswordsController

  layout 'bushido'
  include CurrentCart
  before_action :set_cart

  include CurrentProject
  helper_method :current_project

  def best_seller_product
    @best_seller ||= Product.first
  end
  helper_method :best_seller_product


  def new
    super
  end

end