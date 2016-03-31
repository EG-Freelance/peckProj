class AddColumnsToProduct < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.text :name
      t.text :description
    end
  end
end
