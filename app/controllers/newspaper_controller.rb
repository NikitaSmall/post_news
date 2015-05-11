class NewspaperController < ApplicationController

  layout 'application'

  def index
    @posts = Post.main.by_position
    @featured_posts = Post.featured.by_position
  end

  def archive
    @posts = Post.hidden.by_position
  end

  def all
    @posts = Post.all.by_position
  end

  def read
    @post = Post.find(params[:id])
  end

  def all_users
    @users = User.all
  end
end
