class UserController < ApplicationController
  before_action :set_user, only: [:view, :to_admin, :to_author, :to_corrector, :to_editor]
  before_action :authenticate_user!, except: [:view]
  before_action :check_role, except: [:view]

  layout :resolve_layout

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => 7)
  end

  # GET /users/1
  def view
  end

  # PATCH /users/to_corrector/1
  def to_corrector
    @user.corrector!

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  # PATCH /users/to_author/1
  def to_author
    @user.author!

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  # PATCH /users/to_editor/1
  def to_editor
    @user.editor!

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  # PATCH /users/to_admin/1
  def to_admin
    @user.admin!

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  protected
  def set_user
    @user = User.find(params[:id])
  end

  def check_role
    redirect_to root_path, notice: 'Ты ещё слишком молод для этого.' if current_user.newbie?

    unless current_user.admin? || params[:action] == 'index'
      redirect_to users_url, notice: 'Ты не можешь менять ранг.'
    end
  end

  def resolve_layout
    case params[:action]
      when 'view'
        'application'
      else
        'admin'
    end
  end
end
