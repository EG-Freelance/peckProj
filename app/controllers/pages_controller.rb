class PagesController < ApplicationController
  def all_users
    @owners = User.includes(:user_registries).where(:user_registries => { association_type: "owner" })
  end
end
