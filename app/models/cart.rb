class Cart < ActiveRecord::Base
  belongs_to :user
  #has_many :cart_products
  #has_many :products, through: :cart_products
  has_many :cart_offers, :dependent => :destroy
  has_many :offers, through: :cart_offers
end