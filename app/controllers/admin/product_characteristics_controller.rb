class ProductCharacteristicsController < ApplicationController
  before_action :set_product_characteristic, only: [:show, :edit, :update, :destroy]

  # GET /product_characteristics
  def index
    @product_characteristics = ProductCharacteristic.all
  end

  # GET /product_characteristics/1
  def show
  end

  # GET /product_characteristics/new
  def new
    @product_characteristic = ProductCharacteristic.new
  end

  # GET /product_characteristics/1/edit
  def edit
  end

  # POST /product_characteristics
  def create
    @product_characteristic = ProductCharacteristic.new(product_characteristic_params)

    if @product_characteristic.save
      redirect_to @product_characteristic, notice: 'Product characteristic was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /product_characteristics/1
  def update
    if @product_characteristic.update(product_characteristic_params)
      redirect_to @product_characteristic, notice: 'Product characteristic was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /product_characteristics/1
  def destroy
    @product_characteristic.destroy
    redirect_to product_characteristics_url, notice: 'Product characteristic was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_characteristic
      @product_characteristic = ProductCharacteristic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_characteristic_params
      params.require(:product_characteristic).permit(:product_id, :characteristic_name_id, :characteristic_value_id)
    end
end
