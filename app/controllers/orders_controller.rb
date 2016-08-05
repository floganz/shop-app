class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, :only => [:update, :index]
  after_action :after_save, :only => [:update]

  def index
    @items = @order.order_items
  end

  def update
    @order = Order.update params[:id], order_params.merge({:active => false})
    if @order.save
      flash[:success] = "Order complited"
      OrderMailer.order_notification(@order).deliver!
    else
      flash[:danger] = "Something go wrong"
    end
    redirect_to root_path
  end

  def show
    @order = Order.find params[:id]
    @order_items = @order.order_items
  end

  private
    def set_order
      @order = Order.cur_user(current_user.id).active.first
      logger.debug @order
      if @order.nil?
        @order = Order.new :user_id => current_user.id
      end
    end

    def order_params
      params.require(:order).permit(:total)
    end

    def after_save
      @order.order_items.each do |item|
        @product = item.product
        @product.update({:quantity => @product.quantity - item.quantity})
      end
    end
end
