class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :popshops_index
      t.string :name
      t.integer :count

      t.timestamps
    end
  end
end
