class BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout 'bushido'

  include CurrentCart
  before_action :set_cart

  include CurrentProject
  helper_method :current_project

  def best_seller_product
    @best_seller ||= Product.first
  end
  helper_method :best_seller_product

  def comparing_ids
    session[:comparing_ids] ||= []
  end

  def comparing_products
    @products = Product.aviable.find(comparing_ids)
  end
  helper_method :comparing_ids, :comparing_products

  before_action :set_posts
  def set_posts
    @posts = Post.all
  end

  before_action :set_new_message
  def set_new_message
    @message = Message.new
  end

end
