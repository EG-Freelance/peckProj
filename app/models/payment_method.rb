class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :registries
  
  validates_presence_of :provider
  validates_presence_of :username
  validates_presence_of :custom_name
end