class Admin::CharacteristicsGroupsController < Admin::BaseController
  before_action :set_characteristics_group, only: [:show, :edit, :update, :destroy]

  # GET /characteristics_groups
  def index
    @characteristics_groups = CharacteristicsGroup.all
  end

  # GET /characteristics_groups/1
  def show
  end

  # GET /characteristics_groups/new
  def new
    @characteristics_group = CharacteristicsGroup.new
  end

  # GET /characteristics_groups/1/edit
  def edit
  end

  # POST /characteristics_groups
  def create
    @characteristics_group = CharacteristicsGroup.new(characteristics_group_params)

    if @characteristics_group.save
      redirect_to @characteristics_group, notice: 'Characteristics group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /characteristics_groups/1
  def update
    if @characteristics_group.update(characteristics_group_params)
      redirect_to @characteristics_group, notice: 'Characteristics group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /characteristics_groups/1
  def destroy
    @characteristics_group.destroy
    redirect_to characteristics_groups_url, notice: 'Characteristics group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_characteristics_group
      @characteristics_group = CharacteristicsGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def characteristics_group_params
      params.require(:characteristics_group).permit(:title)
    end
end
