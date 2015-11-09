class CouponsController < BaseController

  def check
    @error = false
    @message = ""

    #ищем купон
    @coupon = Coupon.find_by(code: params[:code])
    if @coupon #если нашли купон
      if @coupon.user #если принадлежит пользователю то првоерим, наш ли это пользователь
        current_user == @coupon.user ? @error = false : @error = true
        @message = "Данный купон принадлежит другому пользователю." if @error
      end
      if @coupon.used_at && !@coupon.reusable?
        @error = true
        @message = "Купон уже был использован " + l(@coupon.used_at, format: :long).to_s
      end
    else
      @error = true
      @message = "Купон не найден."
    end

    unless @error
      @cart.coupon = @coupon
      @cart.save
    end

    respond_to do |format|
      format.js
    end

  end

end
