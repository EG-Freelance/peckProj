class CreateProductsRegistriesAssociationTable < ActiveRecord::Migration
  def change
    drop_table :registries
    drop_table :products
    drop_table :product_registries
    
    create_table :registries do |t|
      t.boolean :active, :default => true
      t.text :name
    end
   
    create_table :products do |t|
      t.text :name
      t.text :description
    end
    
    create_table :product_registries do |t|
      t.belongs_to :product
      t.belongs_to :registry
    end
  end
end
