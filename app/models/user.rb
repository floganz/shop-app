class User < ApplicationRecord
  has_many :orders
  has_many :order_items, through: :orders
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :vk, :google_oauth2, :github]

  def history
    self.orders.where(:active => false)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    logger.debug "DATA = #{access_token.info}"
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(
           email: data["email"],
           password: Devise.friendly_token[0,20]
        )
    end
    user
  end

  def self.from_omniauth_git(access_token)
    data = access_token.info
    logger.debug "DATA = #{access_token.info}"
    user = User.where(:uid => data["nickname"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(
           email: data["email"],
           password: Devise.friendly_token[0,20],
           provider: "git",
           uid: data['nickname']
        )
    end
    user
  end
end
