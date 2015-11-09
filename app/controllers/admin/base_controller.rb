class Admin::BaseController < ApplicationController
  http_basic_authenticate_with(
    name:     Rails.application.secrets.admin_login,
    password: Rails.application.secrets.admin_password
  ) if Rails.env.production?

  layout 'admin'

  include CurrentProject
  helper_method :current_project

end
