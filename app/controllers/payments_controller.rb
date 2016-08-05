class PaymentsController < ApplicationController
  before_action :set_order, :only => [:new, :execute]

  def new
    @payment = PayPal::SDK::REST::Payment.new payment_params

    if @payment.create
      @redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
      @payment_local = Payment.create({
        :payment_id => @payment.id,
        :order_id => @order.id,
        :total => @payment.transactions.last.amount.total
      })
      @order.update({ :total => params[:total][:val] })
      redirect_to @redirect_url and return
    else
      logger.error @payment.error.inspect
    end
    redirect_to root_path
  end

  def execute
    payment = PayPal::SDK::REST::Payment.find params[:paymentId]
    if payment.execute(:payer_id => params[:PayerID])
      @payment = Payment.find_by :payment_id => payment.id
      @payment.update(:complited => true)
      if @order.order_valid?
        flash[:success] = "Ordr validation complite"
        OrderMailer.order_notification(@order).deliver!
      else
        flash[:danger] = "Order validation error"
        OrderMailer.order_fail(@order).deliver!
      end
    else
      payment.error # Error Hash
      flash[:danger] = "Payment failed"
    end
    redirect_to root_path
  end

  private
    def set_order
      @order = Order.cur_user(current_user.id).active.first
    end

    def payment_params
      {
        :intent =>  "sale",
        :payer =>  {
          :payment_method =>  "paypal" },
        :redirect_urls => {
          :return_url => "http://localhost:3000/payments/execute",
          :cancel_url => "http://localhost:3000/" },
        :description =>  "This is the payment transaction description." 
      }
      .merge({
        :transactions =>  [{
          :amount => {
            :total => params[:total][:val],
            :currency => "USD" }
        }]
      })
    end
end
