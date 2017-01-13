class CreateCartOffer < ActiveRecord::Migration
  def change
    create_table :cart_offers do |t|
      t.belongs_to :cart
      t.belongs_to :offer
      t.belongs_to :registry
      t.belongs_to :product
      t.integer :quantity
      
      t.timestamps
    end
  end
end
