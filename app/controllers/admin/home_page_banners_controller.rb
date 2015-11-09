class Admin::HomePageBannersController < Admin::BaseController
  before_action :set_home_page_banner, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @home_page_banners = HomePageBanner.all
    respond_with(@home_page_banners)
  end

  def show
    respond_with(@home_page_banner)
  end

  def new
    @home_page_banner = HomePageBanner.new
    respond_with(@home_page_banner)
  end

  def edit
  end

  def create
    @home_page_banner = HomePageBanner.new(home_page_banner_params)
    @home_page_banner.save
    # respond_with(@home_page_banner)
    respond_to do |format|
      format.html { redirect_to home_page_banners_path }
    end
  end

  def update
    @home_page_banner.update(home_page_banner_params)
    # respond_with(@home_page_banner)
    respond_to do |format|
      format.html { redirect_to home_page_banners_path }
    end
  end

  def destroy
    @home_page_banner.destroy
    # respond_with(@home_page_banner)
    respond_to do |format|
      format.html { redirect_to home_page_banners_path }
    end
  end

  private
    def set_home_page_banner
      @home_page_banner = HomePageBanner.find(params[:id])
    end

    def home_page_banner_params
      params.require(:home_page_banner).permit(:title, :title_red, :title_small, :description, :main_button_title, :main_button_url, :secondary_button_on, :secondary_button_title, :secondary_button_url, :image_big, :image_small, :published)
    end

end
