class UserController < ApplicationController
  before_action :authenticate_user!, except: [:view]
  before_action :check_role, except: [:index, :view]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def view
    @user = User.find(params[:id])
  end

  # PATCH /users/to_corrector/1
  def to_corrector
    user = User.find(params[:id])
    user.corrector!

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  # PATCH /users/to_author/1
  def to_author
    user = User.find(params[:id])
    user.author!

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  # PATCH /users/to_editor/1
  def to_editor
    user = User.find(params[:id])
    user.editor!

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  # PATCH /users/to_admin/1
  def to_admin
    user = User.find(params[:id])
    user.admin!

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  protected
  def check_role
    redirect_to root_path, notice: 'Ты ещё слишком молод для этого.' if current_user.newbie?

    unless current_user.admin?
      redirect_to users_url, notice: 'Ты не можешь менять ранг.'
    end
  end
end
