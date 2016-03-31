class ChangeAssociationColumnName < ActiveRecord::Migration
  def change
    rename_column :user_registries, :association, :association_type
  end
end
