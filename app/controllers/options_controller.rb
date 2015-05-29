class OptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_role

  layout 'admin'

  def index
    @options = Option.get_options
  end

  def set_option
    Option.set_value params[:name], params[:value]

    respond_to do |format|
      format.html { redirect_to options_path }
      format.js {}
    end
  end

  private
  def check_role
    redirect_to root_path, notice: 'Ты ещё слишком молод для этого.' if current_user.newbie?
    redirect_to posts_path, notice: 'У вас нет прав для управления настройками.' if current_user.corrector? || current_user.author?
  end
end
