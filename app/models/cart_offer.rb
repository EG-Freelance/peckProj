class CartOffer < ActiveRecord::Base
  belongs_to :offer
  belongs_to :cart
  belongs_to :registry
  belongs_to :product
end
