class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.belongs_to :user
      
      t.string :provider
      t.string :username

      t.timestamps
    end
    
  end
end
