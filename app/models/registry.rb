class Registry < ActiveRecord::Base
  has_many :user_registries
  has_many :users, :through => :user_registries
  has_many :product_registries
  has_many :products, :through => :product_registries
end
