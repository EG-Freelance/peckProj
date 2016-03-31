class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_registries
  has_many :registries, :through => :user_registries
  
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
