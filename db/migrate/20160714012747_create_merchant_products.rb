class CreateMerchantProducts < ActiveRecord::Migration
  def change
    create_table :merchant_products do |t|
      t.belongs_to :product
      t.belongs_to :merchant

      t.timestamps
    end
  end
end
