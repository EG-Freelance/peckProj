class AddRegistryOwnershipToPaymentMethod < ActiveRecord::Migration
  def change
    change_table :registries do |t|
      t.belongs_to :payment_method
    end
  end
end
