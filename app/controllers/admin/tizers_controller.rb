class Admin::TizersController < Admin::BaseController
  before_action :set_tizer, only: [:show, :edit, :update, :destroy]

  # GET /admin/tizers
  # GET /admin/tizers.json
  def index
    @tizers = Tizer.all
  end

  # GET /admin/tizers/1
  # GET /admin/tizers/1.json
  def show
  end

  # GET /admin/tizers/new
  def new
    @tizer = Tizer.new
    if Project.count == 1
      @tizer.project_ids = Project.first.id
    end
  end

  # GET /admin/tizers/1/edit
  def edit
  end

  # POST /admin/tizers
  # POST /admin/tizers.json
  def create
    @tizer = Tizer.new(tizer_params)

    respond_to do |format|
      if @tizer.save
        format.html { redirect_to admin_tizers_path, notice: 'Tizer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tizer }
      else
        format.html { render action: 'new' }
        format.json { render json: @tizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tizers/1
  # PATCH/PUT /admin/tizers/1.json
  def update
    respond_to do |format|
      if @tizer.update(tizer_params)
        format.html { redirect_to admin_tizers_path, notice: 'Tizer was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @tizer }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tizers/1
  # DELETE /admin/tizers/1.json
  def destroy
    @tizer.destroy
    respond_to do |format|
      format.html { redirect_to admin_tizers_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tizer
      @tizer = Tizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tizer_params
      params.require(:tizer).permit(:title, :url)
    end
end
