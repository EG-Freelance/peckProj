class CreateMerchantTypes < ActiveRecord::Migration
  def change
    create_table :merchant_types do |t|
      t.string :popshops_index
      t.string :name

      t.timestamps
    end
  end
end
