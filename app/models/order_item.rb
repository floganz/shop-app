class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :user, through: :order
end
