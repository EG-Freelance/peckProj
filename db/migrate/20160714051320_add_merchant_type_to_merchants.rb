class AddMerchantTypeToMerchants < ActiveRecord::Migration
  def change
    add_reference :merchants, :merchant_type, index: true
  end
end
