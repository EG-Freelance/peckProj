class AddQuantityPurchasedToProductRegistry < ActiveRecord::Migration
  def change
    change_table :product_registries do |t|
      t.integer :purchased
    end
  end
end
