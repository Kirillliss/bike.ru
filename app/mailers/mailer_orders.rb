class MailerOrders < ActionMailer::Base
  default from: "noreply@spine-sport.ru"

  def send_to_user(order)
    @order = order
    subject = 'Ваш заказ принят'
    mail(to: order.user.email, subject: subject)
  end

  def send_to_manager(order)
    @order = order
    subject = 'Поступил новый заказ'
    mail(to: Rails.application.secrets.notifications_email, subject: subject)
  end

end
