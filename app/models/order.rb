class Order < ApplicationRecord
  belongs_to :user
  belongs_to :payment
  has_many :order_items
  has_many :products, through: :order_items

  scope :active, -> { where(active: true) }
  scope :cur_user, -> (id) { where(:user_id => id) }

  def order_valid?
    #begin
      Product.transaction do
        self.order_items.each do |item|
          @product = item.product
          @product.update!({:quantity => @product.quantity - item.quantity})
        end
        self.update!(:active => false)
        return true
      end
    rescue ActiveRecord::RecordInvalid => exception
      return false
    #end
  end
end
