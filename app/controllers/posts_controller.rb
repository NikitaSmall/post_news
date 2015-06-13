class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :feature, :defeature, :to_main, :hide]
  before_action :authenticate_user!
  before_action :check_role
  before_action :check_empty_page, only: [:index, :hidden, :my_posts]

  layout 'admin'

  # GET /posts
  # GET /posts.json
  def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).by_position.paginate(:page => params[:page], :per_page => 7)
    elsif params[:word]
      @posts = Post.search(params[:word]).by_position.paginate(:page => params[:page], :per_page => 7)
    else
      @posts = Post.all.by_position.paginate(:page => params[:page], :per_page => 7)
    end
  end

  def main
    @posts = Post.main.by_position
  end

  def hidden
    @posts = Post.hidden.by_position.paginate(:page => params[:page], :per_page => 7)
  end

  # GET /posts_my
  def my_posts
    @posts = Post.user_posts(current_user).by_position.paginate(:page => params[:page], :per_page => 7)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        #@post.set_position
        format.html { redirect_to @post, notice: 'Новость была успешно добавлена.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Новость была успешно обновлена.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /switch/1/2
  def switch
    @first = Post.find(params[:first])
    @second = Post.find(params[:second])

    @first.switch @second

    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end

  # PATCH/PUT /switch/1
  def switch_with_next
    @first = Post.find(params[:first])
    @second = @first.next

    if @second.present?
      @first.switch @second
    end

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.js {}
    end
  end

  # PATCH/PUT /switch/2
  def switch_with_prev
    @first = Post.find(params[:first])
    @second = @first.prev

    if @second.present?
      @first.switch @second
    end

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.js {}
    end
  end

  # PATCH/PUT /feature/1
  def feature
    @post.featured!

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.js {}
    end
  end

  # PATCH/PUT /defeature/1
  def defeature
    @post.defeature!

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.js {}
    end
  end

  def to_main
    @post.main!

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.js {}
    end
  end

  def hide
    @post.hide!

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.js {}
    end
  end

  # PATCH/PUT /switch/1
  def switch_with_next_main
    @first = Post.find(params[:first])
    @second = @first.next_main

    if @second.present?
      @first.switch @second
    end

    respond_to do |format|
      format.html { redirect_to main_posts_url }
      format.js {}
    end
  end

  # PATCH/PUT /switch/2
  def switch_with_prev_main
    @first = Post.find(params[:first])
    @second = @first.prev_main

    if @second.present?
      @first.switch @second
    end

    respond_to do |format|
      format.html { redirect_to main_posts_url }
      format.js {}
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.js {}
      format.json { head :no_content }
    end
  end

  def check_title
    @post = Post.find_by_title(params[:post][:title])

    if @post.nil?
      message = true
    else
      message = 'Название должно быть уникальным'
    end

    respond_to do |format|
      format.json { render json: message.to_json }
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :user, :main, :featured, :position, :tag_list, :photo)
    end

    def check_empty_page
      if params[:action] == 'hidden'
        params[:page] = (params[:page].to_i - 1).to_s while Post.hidden.by_position.paginate(:page => params[:page], :per_page => 7).empty? unless Post.hidden.empty?
      end
      if params[:action] == 'my_posts'
        params[:page] = (params[:page].to_i - 1).to_s while Post.user_posts(current_user).by_position.paginate(:page => params[:page], :per_page => 7).empty? unless Post.user_posts(current_user).empty?
      end
      if params[:action] == 'index'
        unless params[:tag].nil?
          unless Post.tagged_with(params[:tag]).empty?
            params[:page] = (params[:page].to_i - 1).to_s while Post.tagged_with(params[:tag]).by_position.paginate(:page => params[:page], :per_page => 7).empty?
          end
        end

        unless params[:word].nil?
          unless Post.search(params[:word]).empty?
            params[:page] = (params[:page].to_i - 1).to_s while Post.search(params[:word]).by_position.paginate(:page => params[:page], :per_page => 7).empty?
          end
        end

        params[:page] = (params[:page].to_i - 1).to_s while Post.all.by_position.paginate(:page => params[:page], :per_page => 7).empty? if params[:tag].nil? && params[:word].nil? && !Post.all.empty?
      end
    end

    def check_role
      redirect_to root_path, notice: 'Ты ещё слишком молод для этого.' if current_user.newbie?

      if (params[:action] == 'new' || params[:action] == 'create' ||
          params[:action] == 'destroy' || params[:action] == 'switch' ||
          # params[:action] == 'switch_with_next' || params[:action] == 'switch_with_prev' ||
          # params[:action] == 'switch_with_next_main' || params[:action] == 'switch_with_prev_main' ||
          params[:action] == 'feature' || params[:action] == 'defeature' ||
          params[:action] == 'to_main' || params[:action] == 'hide') && current_user.corrector?
        redirect_to posts_url, notice: 'Ты не можешь создавать новый контент.'
      end

      if (params[:action] == 'update' || params[:action] == 'edit') && current_user.author? && current_user.id != @post.user.id
        redirect_to posts_url, notice: 'Ты не можешь менять чужой контент.'
      end

      if (params[:action] == 'switch' || params[:action] == 'switch_with_next' ||
          params[:action] == 'switch_with_prev' || params[:action] == 'feature' ||
          params[:action] == 'defeature' || params[:action] == 'to_main' ||
          params[:action] == 'hide' || params[:action] == 'switch_with_next_main' ||
          params[:action] == 'switch_with_prev_main' || params[:action] == 'destroy') && current_user.author?
        redirect_to posts_url, notice: 'Ты не можешь менять порядок.'
      end
    end
end