class ResetProductTable < ActiveRecord::Migration
  def change
    drop_table :products
    
    create_table :products do |t|
      t.text :name
      t.text :description
    end
  end
end
