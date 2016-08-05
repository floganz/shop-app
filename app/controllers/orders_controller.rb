class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, :only => [:update, :index, :order_validation]
  #after_rollback :custom_error, on: :update

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

    def custom_error
      flash[:danger] = "Order validation error (custom_error)"
      OrderMailer.order_fail(@order).deliver!
      redirect_to root_path and return    
    end
end
