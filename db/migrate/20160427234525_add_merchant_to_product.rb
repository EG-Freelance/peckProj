class AddMerchantToProduct < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.string :merchant
    end
  end
end
