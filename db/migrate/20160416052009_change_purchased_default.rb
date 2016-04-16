class ChangePurchasedDefault < ActiveRecord::Migration
  def change
    change_column_default :product_registries, :purchased, 0
  end
end
