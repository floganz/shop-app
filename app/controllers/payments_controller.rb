class PaymentsController < ApplicationController
  before_action :set_user, :only => [:index]
  #include payment_custom

  def getresponce
    flash[:success] = "All done"
    redirect_to root_path
  end

  def new
    @payment = PayPal::SDK::REST::Payment.new payment_params

    # Create Payment and return status
    if @payment.create
      # Redirect the user to given approval url
      @redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
      logger.info "Payment[#{@payment.id}]"
      logger.info "Redirect: #{@redirect_url}"
    else
      logger.error @payment.error.inspect
    end
  end

  def execute
    payment = Payment.find params[:id]

    if payment.execute( :payer_id => params[:payer_id] )
      flash[:success] = "All done with execute"
      redirect_to root_path
    else
      payment.error # Error Hash
      flash[:danger] = "Failed with execute"
      redirect_to root_path
    end
  end

  def makepayment
    payment = Payment.find params[:id]

    if payment.execute( :payer_id => "DUFRQ8GWYMJXC" )
      flash[:success] = "All done with makepayment"
      redirect_to root_path
      # Success Message
      # Note that you'll need to `Payment.find` the payment again to access user info like shipping address
    else
      payment.error # Error Hash
      flash[:danger] = "Failed with makepayment"
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user.id)
    end

    def payment_params
      {
        :intent =>  "sale",
        :payer =>  {
          :payment_method =>  "paypal" },
        :redirect_urls => {
          :return_url => "http://localhost:3000/payments/execute",
          :cancel_url => "http://localhost:3000/" },

        :transactions =>  [{}],
        :description =>  "This is the payment transaction description." 
      }
      .merge({
        :amount => {
          :total => params[:total],
          :currency => "USD" }
      })
    end
end
