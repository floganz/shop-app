class OrdersController < ApplicationController
  before_action :authenticate_user!, :set_order

  def index
    @items = @order.order_info
  end

  def update
    @order = Order.update params[:id], order_params.merge({:active => false})
    if @order.save
      flash[:success] = "Order complited"
      OrderMailer.order_notification(@order).deliver!
      @order.update_storage
    else
      flash[:danger] = "Something go wrong"
    end
    redirect_to root_path
  end

  def show
    @order = Order.find params[:id]
    @order_items = @order.order_info
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
