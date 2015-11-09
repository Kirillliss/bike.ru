class WelcomeController < BaseController
  def index
    @banners = Banner.published.slider
  end
end
