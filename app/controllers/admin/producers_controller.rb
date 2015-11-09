class Admin::ProducersController < Admin::BaseController
  before_action :set_producer, only: [:show, :edit, :update, :destroy]

  # GET /producers
  def index
    @producers = Producer.all
  end

  # GET /producers/1
  def show
  end

  # GET /producers/new
  def new
    @producer = Producer.new
  end

  # GET /producers/1/edit
  def edit
  end

  # POST /producers
  def create
    @producer = Producer.new(producer_params)

    if @producer.save
      redirect_to @producer, notice: 'Producer was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /producers/1
  def update
    if @producer.update(producer_params)
      redirect_to @producer, notice: 'Producer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /producers/1
  def destroy
    @producer.destroy
    redirect_to producers_url, notice: 'Producer was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_producer
      @producer = Producer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def producer_params
      params.require(:producer).permit(:title)
    end
end
