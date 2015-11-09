class DealsController < BaseController
  before_action :check_aviable_deals
  
  def index
    @deals = Deal.aviable
  end

  def show
    @deal = Deal.aviable.find(params[:id])
  end

  private
    def check_aviable_deals
      redirect_to root_path unless Deal.aviable.any?
    end
end
