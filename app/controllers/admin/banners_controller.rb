class Admin::BannersController < Admin::BaseController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  # GET /admin/banners
  # GET /admin/banners.json
  def index
    @banners = Banner.all
  end

  # GET /admin/banners/1
  # GET /admin/banners/1.json
  def show
  end

  # GET /admin/banners/new
  def new
    @banner = Banner.new
    # if Project.count == 1
    #   @banner.project_ids = Project.first.id
    # end
  end

  # GET /admin/banners/1/edit
  def edit
  end

  # POST /admin/banners
  # POST /admin/banners.json
  def create
    @banner = Banner.new(banner_params)

    respond_to do |format|
      if @banner.save
        format.html { redirect_to admin_banners_path, notice: 'Banner was successfully created.' }
        format.json { render action: 'show', status: :created, location: @banner }
      else
        format.html { render action: 'new' }
        format.json { render json: @banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/banners/1
  # PATCH/PUT /admin/banners/1.json
  def update
    respond_to do |format|
      if @banner.update(banner_params)
        format.html { redirect_to admin_banners_path, notice: 'Banner was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @banner }
      else
        format.html { render action: 'edit' }
        format.json { render json: @banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/banners/1
  # DELETE /admin/banners/1.json
  def destroy
    @banner.destroy
    respond_to do |format|
      format.html { redirect_to admin_banners_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def banner_params
      params.require(:banner).permit(:title, :url, :text, :image, :topable, :leftable, :published)
    end
end
