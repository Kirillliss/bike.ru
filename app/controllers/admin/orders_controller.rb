class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.order(created_at: :desc)

    respond_to do |format|
      format.html
      # format.xml { render xml: Order.to_xml_1c(Order.all) }
      format.xml { render xml: Order.last.to_xml_1c }
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def ship
    @order = Order.find(params[:id])

    if @order.ship
     redirect_to action: :show, notice: 'Заказ успешно изменен'
    else
      redirect_to action: :show, notice: 'Невозможно изменить заказ'
    end
  end

  def cancel
    @order = Order.find(params[:id])

    if @order.cancel
      flash[:notice] =  'Заказ успешно изменен'
      redirect_to action: :show
    else
     redirect_to action: :show, notice: 'Невозможно измененить заказ'
    end
  end

end
