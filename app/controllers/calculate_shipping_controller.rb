require 'calculate_shipping'

class CalculateShippingController < BaseController

  def calculate
    @cart.update(region_title: params[:region_title], city_title: params[:city_title], region_code: params[:region], city_code: params[:location])
    calc_shipping = CalculateShipping.new()
    # Получаем xml с вариантами доставки:
    @response_xml = calc_shipping.calculate(to_city: params[:location])
    # Выводим вараинты доставки пользователю:
    respond_to do |format|
      format.js
    end
  end

  def select_price_of_shipping
    @cart.price_of_shipping = params[:price_of_shipping].split(',').first
    @cart.kind_of_shipping = params[:price_of_shipping].split(',').second
    @cart.save
    respond_to do |format|
      format.js
    end
  end

end
