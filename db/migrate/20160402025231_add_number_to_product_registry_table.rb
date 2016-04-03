class AddNumberToProductRegistryTable < ActiveRecord::Migration
  def change
    change_table :product_registries do |t|
      t.integer :quantity
    end
  end
end
