class OrderMailer < ApplicationMailer
  default :from => 'admin@shop-app.com'

  def order_notification(order)
    @order = order
    mail :to => @order.user.email, :subject => "Order notification"
  end

end
