class CreateUserRegistries < ActiveRecord::Migration
  def change
    create_table :user_registries do |t|
      t.belongs_to :user
      t.belongs_to :registry
      t.string :association
      t.string :preference
      t.text :account

      t.timestamps
    end
  end
end
