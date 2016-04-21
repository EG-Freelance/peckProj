class Product < ActiveRecord::Base
  has_many :product_registries
  has_many :registries, :through => :product_registries
  has_many :cart_products
  has_many :carts, through: :cart_products
  
end