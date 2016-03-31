class ProductRegistry < ActiveRecord::Base
  belongs_to :registry
  belongs_to :product
end
