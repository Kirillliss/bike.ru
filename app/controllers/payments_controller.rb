class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_payment

  # POST /payments/result
  def result
    if !@payment.verify_params(params[:OutSum], params[:SignatureValue])
      @payment.cancel!
      raise Forbidden
    end

    @payment.pay!
    @payment.order.pay!

    env['api.format'] = :txt
    render text: "OK#{params[:InvId]}", status: 200
  end

  # POST /payments/success
  def success
    redirect_to root_url, notice: "Оплата произведене успешно!"
  end

  # POST /payments/cancel
  def cancel
    redirect_to root_url, notice: "Оплата отменена!"
  end

  protected

  def set_payment
    @payment = Payment.find(params[:InvId])
    raise Forbidden unless @payment
  end

end
