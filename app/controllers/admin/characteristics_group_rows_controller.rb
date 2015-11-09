class Admin::CharacteristicsGroupRowsController < Admin::BaseController
  before_action :set_characteristics_group_row, only: [:show, :edit, :update, :destroy]

  # GET /characteristics_group_rows
  def index
    @characteristics_group_rows = CharacteristicsGroupRow.all
  end

  # GET /characteristics_group_rows/1
  def show
  end

  # GET /characteristics_group_rows/new
  def new
    @characteristics_group_row = CharacteristicsGroupRow.new
  end

  # GET /characteristics_group_rows/1/edit
  def edit
  end

  # POST /characteristics_group_rows
  def create
    @characteristics_group_row = CharacteristicsGroupRow.new(characteristics_group_row_params)

    if @characteristics_group_row.save
      redirect_to @characteristics_group_row, notice: 'Characteristics group row was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /characteristics_group_rows/1
  def update
    if @characteristics_group_row.update(characteristics_group_row_params)
      redirect_to @characteristics_group_row, notice: 'Characteristics group row was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /characteristics_group_rows/1
  def destroy
    @characteristics_group_row.destroy
    redirect_to characteristics_group_rows_url, notice: 'Characteristics group row was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_characteristics_group_row
      @characteristics_group_row = CharacteristicsGroupRow.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def characteristics_group_row_params
      params.require(:characteristics_group_row).permit(:characteristics_group_id, :characteristic_name_id)
    end
end
