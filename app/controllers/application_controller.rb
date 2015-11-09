class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def after_sign_in_path_for(resource)
    if session[:back_url].present?
      url_to_go = session[:back_url]
      session[:back_url] = nil
      url_to_go
    else
      super
    end
  end

end
