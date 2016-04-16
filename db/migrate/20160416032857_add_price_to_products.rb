class AddPriceToProducts < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.decimal :price
      t.decimal :fund
    end
  end
end
