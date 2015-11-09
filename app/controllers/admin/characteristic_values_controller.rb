class Admin::CharacteristicValuesController < Admin::BaseController
  before_action :set_characteristic_value, only: [:show, :edit, :update, :destroy]

  # GET /characteristic_values
  def index
    @characteristic_values = CharacteristicValue.all
  end

  # GET /characteristic_values/1
  def show
  end

  # GET /characteristic_values/new
  def new
    @characteristic_value = CharacteristicValue.new
  end

  # GET /characteristic_values/1/edit
  def edit
  end

  # POST /characteristic_values
  def create
    @characteristic_value = CharacteristicValue.new(characteristic_value_params)

    if @characteristic_value.save
      redirect_to @characteristic_value, notice: 'Characteristic value was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /characteristic_values/1
  def update
    if @characteristic_value.update(characteristic_value_params)
      redirect_to @characteristic_value, notice: 'Characteristic value was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /characteristic_values/1
  def destroy
    @characteristic_value.destroy
    redirect_to characteristic_values_url, notice: 'Characteristic value was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_characteristic_value
      @characteristic_value = CharacteristicValue.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def characteristic_value_params
      params.require(:characteristic_value).permit(:value, :characteristic_id)
    end
end
