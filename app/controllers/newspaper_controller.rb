class NewspaperController < ApplicationController
  before_filter :get_popular_tags
  before_action :set_post, only: [:read, :share]
  layout 'application'

  def index
    @posts = Post.main.by_position
    @featured_posts = Post.featured.by_position
  end

  def archive
    @posts = Post.hidden.by_position
  end

  def read
  end

  def share
    @post.shared!

    respond_to do |format|
      format.html { redirect_to read_post_url(@post) }
      format.js {}
    end
  end

  def feed
    @posts = Post.all.order(created_at: :desc)
  end

  def all
    @posts = Post.all.by_position
  end

  def all_users
    @users = User.all
  end

  protected
  def get_popular_tags
    @popular_tags = Post.popular_tags(8)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
