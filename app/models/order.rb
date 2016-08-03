class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  scope :active, -> { where(active: true) }
  scope :cur_user, -> (id) { where(:user_id => id) }

  def order_info
    @orderItems = OrderItem.select("order_items.*, products.name")
      .joins(:product)
      .where("order_items.order_id": id)
  end

  def update_storage
    @order_items = OrderItem.order_items id
    @order_items.each do |item|
      @product = Product.find item.product_id
      @product.update({:quantity => @product.quantity - item.quantity})
    end
  end
end
