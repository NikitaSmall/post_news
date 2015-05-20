class AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy, :enable, :disable]
  before_action :authenticate_user!
  before_action :check_role

  layout 'admin'
  respond_to :html, except: [:enable, :disable]

  def index
    @advertisements = Advertisement.all
    respond_with(@advertisements)
  end

  def show
    respond_with(@advertisement)
  end

  def new
    @advertisement = Advertisement.new
    respond_with(@advertisement)
  end

  def edit
  end

  def create
    @advertisement = Advertisement.new(advertisement_params)
    @advertisement.save
    respond_with(@advertisement)
  end

  def update
    @advertisement.update(advertisement_params)
    respond_with(@advertisement)
  end

  def enable
    @advertisement.enabled!

    respond_to do |format|
      format.html { redirect_to advertisements_path }
      format.js {}
    end
  end

  def disable
    @advertisement.disabled!

    respond_to do |format|
      format.html { redirect_to advertisements_path }
      format.js {}
    end
  end

  def destroy
    @advertisement.destroy
    respond_with(@advertisement)
  end

  private
    def set_advertisement
      @advertisement = Advertisement.find(params[:id])
    end

    def advertisement_params
      params.require(:advertisement).permit(:title, :description, :enabled, :photo)
    end

    def check_role
      redirect_to root_path, notice: 'Ты ещё слишком молод для этого.' if current_user.newbie?
      redirect_to posts_path, notice: 'У вас нет прав для управления рекламой.' if current_user.corrector? || current_user.author?
    end
end
