class OrdersController < BaseController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :repeat]

  before_action :restrict_access, only: [:show, :edit, :update, :destroy, :repeat]

  # GET /orders
  # GET /orders.json
  def index
    if current_user
      @orders = current_user.orders.order(created_at: :desc)
      case filter = params[:filter]
      when 'active'
        @orders = @orders.where(state: [:new, :payment_pending, :shipping_pending])
      when 'canceled'
        @orders = @orders.where(state: :canceled)
      end
    else
      redirect_to new_user_session_path
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if current_user
      if @cart.line_items.empty?
        redirect_to root_url, notice: "Корзина пустая"
        return
      end
      @order = Order.new
      @order.user = current_user
    else
      session[:back_url] = new_order_path
      redirect_to new_user_session_path
    end
  end

  # GET /orders/1/edit
  def edit
  end

  def sberbank_receipt

  end

  def kassa_yandex

  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.add_params_from_cart(@cart)
    if @order.save
      if @order.coupon
        @order.coupon.used_at = Time.now
        @order.coupon.save
      end
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      Order.ping_to_chat(@order.id, @order.total_price) if Rails.env.production?
      MailerOrders.send_to_user(@order).deliver
      MailerOrders.send_to_manager(@order).deliver
      # Считаем общую стоимость:
      price_for_pay = @order.total_price(true) + @order.price_of_shipping

      if @order.pay_type == Order::PAYMENT_TYPES[2] # Пластиковая карта --> ROBOKASSA
        payment = Payment.new(order_id: @order.id)
        payment.price = price_for_pay
        payment.save!
        redirect_to payment.remote_url
      elsif @order.pay_type == Order::PAYMENT_TYPES[0] # Квитанция Сбербанк
        render :sberbank_receipt, layout: false
      else
        redirect_to root_url, notice: 'Спасибо за ваш заказ.'
      end

    else
      render action: 'new'
    end

  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @order }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  def exchange_1с
    case params[:mode]
      when 'checkauth'
        render text: 'success'
      when 'init'
        render text: "no\n5242880"
      when 'query'
        render xml: Order.last.to_xml_1c
      when 'success'
        render text: ''
      when 'file'
        # загружаем данные в нашу систему...
        render text: 'success'
    end
  end

  # POST /orders/1/repeat
  def repeat
    render action: :new
  end

  # POST /orders/1/repeat
  def cancel
    if @order.cancel
      redirect_to :back, notice: 'Заказ отменен'
    else
      redirect_to :back, notice: 'Невозможно отменить заказ'
    end
  end

  private
    def restrict_access
      if current_user.nil? || @order.user != current_user
        redirect_to root_url, notice: 'Нет доступа к объекту'
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end
end
