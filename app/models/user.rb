class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
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
    !admin.nil?
  end
end
