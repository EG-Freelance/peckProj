class CreateRegistries < ActiveRecord::Migration
  def change
    create_table :registries do |t|
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
