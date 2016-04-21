class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.belongs_to :user
      t.belongs_to :registry

      t.timestamps
    end
    
    create_table :cart_products do |t|
      t.belongs_to :cart
      t.belongs_to :product
      
      t.integer :quantity
      
      t.timestamps
    end
  end
end