class AddLinkToProduct < ActiveRecord::Migration
  def change
    add_column :products, :affiliate_link, :text
  end
end
