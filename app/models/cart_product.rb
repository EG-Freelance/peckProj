class CartProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  belongs_to :registry
end
