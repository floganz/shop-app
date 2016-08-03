class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :user, through: :order

  scope :order_items, -> (id) { where(:order_id => id)}
end
