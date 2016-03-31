class AddNameToRegistry < ActiveRecord::Migration
  def change
    change_table :registries do |t|
      t.text :name
    end
  end
end
