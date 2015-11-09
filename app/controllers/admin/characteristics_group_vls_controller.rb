class Admin::CharacteristicsGroupVlsController < Admin::BaseController
  before_action :set_characteristics_group_row_value, only: [:show, :edit, :update, :destroy]

  # GET /characteristics_group_row_values
  def index
    @characteristics_group_row_values = CharacteristicsGroupVl.all
  end

  # GET /characteristics_group_row_values/1
  def show
  end

  # GET /characteristics_group_row_values/new
  def new
    @characteristics_group_row_value = CharacteristicsGroupVl.new
  end

  # GET /characteristics_group_row_values/1/edit
  def edit
  end

  # POST /characteristics_group_row_values
  def create
    @characteristics_group_row_value = CharacteristicsGroupVl.new(characteristics_group_row_value_params)

    if @characteristics_group_row_value.save
      redirect_to @characteristics_group_row_value, notice: 'Characteristics group row value was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /characteristics_group_row_values/1
  def update
    if @characteristics_group_row_value.update(characteristics_group_row_value_params)
      redirect_to @characteristics_group_row_value, notice: 'Characteristics group row value was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /characteristics_group_row_values/1
  def destroy
    @characteristics_group_row_value.destroy
    redirect_to characteristics_group_row_values_url, notice: 'Characteristics group row value was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_characteristics_group_row_value
      @characteristics_group_row_value = CharacteristicsGroupVl.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def characteristics_group_row_value_params
      params.require(:characteristics_group_vl).permit(:characteristics_group_row_id, :characteristic_value_id)
    end
end
