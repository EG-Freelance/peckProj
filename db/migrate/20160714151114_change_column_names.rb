class ChangeColumnNames < ActiveRecord::Migration
  drop_table :offers
  create_table :offers do |t|
    t.belongs_to :merchant
    t.belongs_to :product
    t.string :popshops_index
    t.string :sku
    t.string :popshops_merchant
    t.string :name
    t.text :description
    t.text :url
    t.text :image_url_large
    t.string :currency_iso
    t.decimal :price_merchant
    t.decimal :price_retail
    t.decimal :estimated_price_total
    t.string :condition

    t.timestamps
  end
  
  def change
    drop_table :products
    create_table :products do |t|
      t.belongs_to :brand
      t.belongs_to :merchant
      t.string :popshops_index
      t.string :category
      t.string :name
      t.text :description
      t.string :popshops_brand
      t.decimal :price_min
      t.decimal :price_max
      t.integer :offer_count
      t.text :image_url
      
      t.timestamps
    end
    
    create_table :merchants do |t|
      t.belongs_to :merchant_type
      t.string :popshops_index
      t.string :name
      t.string :network
      t.integer :product_count
      t.integer :deal_count
      t.string :network_merchant_id
      t.string :country
      t.string :category
      t.string :popshops_merchant_type
      t.text :logo_url
      t.text :url
      t.text :site_url

      t.timestamps
    end
  end
end
