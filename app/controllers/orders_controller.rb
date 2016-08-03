class OrdersController < ApplicationController
  before_action :authenticate_user!, :set_order

  def index
    #@order ||= Order.new :user_id => current_user.id
    @items = @order.order_info
  end

  def update
    @order = Order.update params[:id], order_params.merge({:active => false})
    if @order.save
      flash[:success] = "Order complited"
      OrderMailer.order_notification(@order).deliver!
      redirect_to root_path
    else
      flash[:warning] = "Something go wrong"
      redirect_to 'products?page=2'
    end
  end

  private
    def set_order
      @order = Order.cur_user(current_user.id).active.first
      if @order.nil?
        @order = Order.new :user_id => current_user.id
      end
    end

    def order_params
      params.require(:order).permit(:total)
    end
end
