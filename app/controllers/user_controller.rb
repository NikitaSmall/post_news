class UserController < ApplicationController
  def index
    @users = User.all
  end

  def view
  end
end
