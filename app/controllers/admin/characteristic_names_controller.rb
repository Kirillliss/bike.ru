class Admin::CharacteristicNamesController < Admin::BaseController
  before_action :set_characteristic, only: [:show, :edit, :update, :destroy]

  # GET /characteristics
  def index
    @characteristics = CharacteristicName.all
  end

  # GET /characteristics/1
  def show
  end

  # GET /characteristics/new
  def new
    @characteristic = CharacteristicName.new
  end

  # GET /characteristics/1/edit
  def edit
  end

  # POST /characteristics
  def create
    @characteristic = CharacteristicName.new(characteristic_params)

    if @characteristic.save
      redirect_to @characteristic, notice: 'Characteristic was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /characteristics/1
  def update
    if @characteristic.update(characteristic_params)
      redirect_to @characteristic, notice: 'Characteristic was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /characteristics/1
  def destroy
    @characteristic.destroy
    redirect_to characteristics_url, notice: 'Characteristic was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_characteristic
      @characteristic = CharacteristicName.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def characteristic_params
      params.require(:characteristic).permit(:title)
    end
end
