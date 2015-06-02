class UserController < ApplicationController
  before_action :set_user, only: [:view, :to_admin, :to_author, :to_corrector, :to_editor, :destroy]
  before_action :authenticate_user!, except: [:view, :check_email, :check_username]
  before_action :check_role, except: [:view, :check_email, :check_username]
  before_action :check_empty_page, only: [:index]

  layout :resolve_layout

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => 7)
  end

  # GET /users/1
  def view
    @user = User.find(current_user.id)
  end

  def change_avatar
    @user = User.find(current_user.id)
    @user.update_attribute(:avatar, params[:user][:avatar])

    respond_to do |format|
      format.html { redirect_to user_url(current_user.id) }
      format.js {}
    end
  end

  def destroy
    @user.destroy
    # @users = User.paginate(:page => params[:page], :per_page => 7)
    respond_to do |format|
      format.html { redirect_to users_url }
      format.js {}
      format.json { head :no_content }
    end
  end

  # PATCH /users/to_corrector/1
  def to_corrector
    @user.corrector! unless user_personality?

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js {}
    end
  end

  # PATCH /users/to_author/1
  def to_author
    @user.author! unless user_personality?

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js {}
    end
  end

  # PATCH /users/to_editor/1
  def to_editor
    @user.editor! unless user_personality?

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js {}
    end
  end

  # PATCH /users/to_admin/1
  def to_admin
    @user.admin!

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js {}
    end
  end

  def check_email
    @user = User.find_by_email(params[:user][:email])

    if @user.nil?
      message = true
    else
      message = 'Эта почта уже используется'
    end

    respond_to do |format|
      format.json { render json: message.to_json }
    end
  end

  def check_username
    @user = User.find_by_username(params[:user][:username])

    if @user.nil?
      message = true
    else
      message = 'Этот ник уже используется'
    end

    respond_to do |format|
      format.json { render json: message.to_json }
    end
  end

  protected
  def set_user
    @user = User.find(params[:id])
  end

  def check_empty_page
    params[:page] = (params[:page].to_i - 1).to_s while User.paginate(:page => params[:page], :per_page => 7).empty?
  end

  def check_role
    redirect_to root_path, notice: 'Ты ещё слишком молод для этого.' if current_user.newbie?

    unless current_user.admin? || params[:action] == 'index'
      redirect_to users_url, notice: 'Ты не можешь менять ранг.'
    end
  end

  def user_personality?
    current_user.id == @user.id
  end

  def resolve_layout
    case params[:action]
      when #'view'
        'application'
      else
        'admin'
    end
  end
end
