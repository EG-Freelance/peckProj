class AddPrivateToRegistryOptions < ActiveRecord::Migration
  def change
    add_column :registries, :private, :boolean
  end
end
