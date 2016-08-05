class Order < ApplicationRecord
  belongs_to :user
  belongs_to :payment
  has_many :order_items
  has_many :products, through: :order_items

  scope :active, -> { where(active: true) }
  scope :cur_user, -> (id) { where(:user_id => id) }
end
