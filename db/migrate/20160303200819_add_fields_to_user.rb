class AddFieldsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :preferred_payment
      t.string :paypal_acct
      t.string :venmo_acct
    end
  end
end
