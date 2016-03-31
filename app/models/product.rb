class Product < ActiveRecord::Base
  has_many :product_registries
  has_many :registries, :through => :product_registries
  
end
