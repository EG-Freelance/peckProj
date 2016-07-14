class Remove < ActiveRecord::Migration
  def change
    remove_column :products, :merchant_id
  end
end
