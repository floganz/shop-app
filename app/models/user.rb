class User < ApplicationRecord
  has_many :orders
  has_many :order_items, through: :orders
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def history
    @orders = Order.select("orders.*")
      .where(:user_id => id)
      .where(:active => false)
  end

  def set_user
    @user = User.find params[:id]
  end
end
