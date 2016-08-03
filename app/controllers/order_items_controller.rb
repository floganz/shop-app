class OrderItemsController < ApplicationController
  def create
    # Check if exist active order for current user, if not - create new
    if Order.cur_user(current_user).active.size == 0
      @order = Order.new :user_id => current_user.id
      @order.save
      ord_id = @order.id
    else
      ord_id = Order.find_by(:user_id => current_user.id, :active => true).id
    end
    @order_item = OrderItem.new item_params.merge({:order_id => ord_id})
    if @order_item.save
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
