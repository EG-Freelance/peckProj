class Offer < ActiveRecord::Base
  belongs_to :product
  belongs_to :merchant
  has_many :cart_offers, :dependent => :destroy
end
