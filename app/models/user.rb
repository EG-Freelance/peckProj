class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :guests, :class_name => 'User', :foreign_key => :owner_id, dependent: :destroy
  belongs_to :owner, :class_name => 'User'
  
  validates :owner_id, presence: true, if: :guest?, unless: :admin?
  validates :preferred_payment, presence: true, if: :owner?
  validates :paypal_acct, presence: true, if: ->(user){user.preferred_payment == "Paypal"}
  validates :venmo_acct, presence: true, if: ->(user){user.preferred_payment == "Venmo"}
  
  def owner?
    owner_id.nil? unless admin?
  end
  
  def guest?
    !owner? unless admin?
  end
  
  def admin?
    self.admin == true
  end
  
  def registry_admin?
    self.owner? || !self.invited_by_id.nil? || self.admin == true
  end
  
  def invitee?
    !self.invited_by_id.nil?
  end
end
