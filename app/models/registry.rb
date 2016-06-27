class Registry < ActiveRecord::Base
  has_many :user_registries, dependent: :destroy
  accepts_nested_attributes_for :user_registries
  has_many :users, :through => :user_registries
  has_many :product_registries, dependent: :destroy
  has_many :products, :through => :product_registries
  belongs_to :payment_method
  has_many :cart_products
  has_many :carts, :through => :cart_products
  
  validates_presence_of :goal
  validates_presence_of :name
  
  def owners
    owners = []
    UserRegistry.where(registry_id: self.id, association_type: 'owner').each { |m| owners << User.find(m.user_id) }
    return owners
  end
  
  def administrators # includes owners
    admins = []
    UserRegistry.where(registry_id: self.id, association_type: 'administrator').each { |m| admins << User.find(m.user_id) }
    self.owners.each{ |o| admins << o }
    return admins
  end
end