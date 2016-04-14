class Registry < ActiveRecord::Base
  has_many :user_registries
  accepts_nested_attributes_for :user_registries
  has_many :users, :through => :user_registries
  has_many :product_registries
  has_many :products, :through => :product_registries
  belongs_to :payment_method
end
