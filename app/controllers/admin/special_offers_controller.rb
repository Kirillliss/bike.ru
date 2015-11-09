class Admin::SpecialOffersController < Admin::BaseController
  before_action :set_special_offer, only: [:show, :edit, :update, :destroy]

  # GET /special_offers
  def index
    @special_offers = SpecialOffer.all
  end

  # GET /special_offers/1
  def show
  end

  # GET /special_offers/new
  def new
    @special_offer = SpecialOffer.new
  end

  # GET /special_offers/1/edit
  def edit
  end

  # POST /special_offers
  def create
    @special_offer = SpecialOffer.new(special_offer_params)

    if @special_offer.save
      # redirect_to @special_offer, notice: 'Special offer was successfully created.'
      redirect_to admin_special_offers_url
    else
      render :new
    end
  end

  # PATCH/PUT /special_offers/1
  def update
    if @special_offer.update(special_offer_params)
      # redirect_to @special_offer, notice: 'Special offer was successfully updated.'
      redirect_to admin_special_offers_url
    else
      render :edit
    end
  end

  # DELETE /special_offers/1
  def destroy
    @special_offer.destroy
    redirect_to admin_special_offers_url, notice: 'Special offer was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_offer
      @special_offer = SpecialOffer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def special_offer_params
      params.require(:special_offer).permit(:product_one_id, :product_two_id, :special_price, :published)
    end
end
