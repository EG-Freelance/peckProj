class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_registries, dependent: :destroy
  has_many :registries, :through => :user_registries
  has_many :payment_methods, dependent: :destroy
  has_one :cart, dependent: :destroy
  
  after_create :create_cart
  
  def create_cart
    Cart.create(user_id: self.id)
  end
  
  def owned_registries
    Registry.joins(:user_registries).where(:user_registries => { :user_id => self.id, :association_type => 'owner' })
  end
  
  def shared_registries
    Registry.joins(:user_registries).where(:user_registries => { :user_id => self.id, :association_type => 'administrator' })
  end
  
  def guest_registries
    Registry.joins(:user_registries).where(:user_registries => { :user_id => self.id, :association_type => 'guest' })
  end
end