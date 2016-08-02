class Product < ApplicationRecord
  has_many :order_item
  has_attached_file :photo, styles: { medium: "200x200>" }, 
    default_url: "/images/:style/photo.jpg"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates :name, :description, presence: true
  validates :price, numericality: { message: "must be number" }
  validates :quantity, numericality: { only_integer: true,
    message: "must be integer" }


  self.per_page = 9

  def self.search_by_key(keyword)
    @products = Product.where("
        products.name LIKE '%#{keyword}' OR
        products.name LIKE '#{keyword}%' OR
        products.name LIKE '%#{keyword}%'")
  end
end