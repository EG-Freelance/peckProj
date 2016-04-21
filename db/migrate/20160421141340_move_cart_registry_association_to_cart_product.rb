class MoveCartRegistryAssociationToCartProduct < ActiveRecord::Migration
  def change
    remove_column :carts, :registry_id
    add_column :cart_products, :registry_id, :integer    
  end
end
