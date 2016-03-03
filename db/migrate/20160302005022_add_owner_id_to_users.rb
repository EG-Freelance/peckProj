class AddOwnerIdToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :owner_id
    end
  end
end
