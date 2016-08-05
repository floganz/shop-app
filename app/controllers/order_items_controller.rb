class OrderItemsController < ApplicationController
  def create
    # Check if exist active order for current user, if not - create new
    unless (@order = Order.cur_user(current_user).active.first)
      @order = current_user.orders.create
    end
    # unless !cookies[:order_id].nil?
    #   @order = current_user.orders.create
    #   cookies[:order_id] = @order.id
    # end
    @order_item = @order.order_items.create item_params
    if @order_item.valid?
      flash[:success] = "Added"
    else
      flash[:danger] = "Something go wrong, try again"
    end
    redirect_to '/products'
  end

  def destroy
    @order_item = OrderItem.find params[:id]
    @order_item.destroy
    redirect_to orders_path
  end

  def item_params
    params.require(:order_item).permit(:product_id, :quantity, :price)    
  end
end
