class RegistrationsController < Devise::RegistrationsController
  before_action :update_sanitized_params, if: :devise_controller?

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

  def create
    super
  end

  def update
    super
  end

  private
    def update_sanitized_params
       devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:full_name, :phone, :name, :email, :password, :password_confirmation)}
    end
end