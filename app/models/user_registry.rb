class UserRegistry < ActiveRecord::Base
  belongs_to :user
  belongs_to :registry
end
