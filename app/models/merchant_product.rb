class MerchantProduct < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :product
end