class ProductRegistry < ActiveRecord::Base
  belongs_to :registry
  belongs_to :product
  validates_numericality_of :quantity, :greater_than => 0
end
