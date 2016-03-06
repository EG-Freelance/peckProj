class PagesController < ApplicationController
  def all_users
    @owners = User.where(owner_id: nil)
  end
end
