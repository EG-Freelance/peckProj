class AddNameToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :custom_name, :string
  end
end
