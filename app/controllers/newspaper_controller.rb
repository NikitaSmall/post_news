class NewspaperController < ApplicationController
  before_filter :set_layout_info

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

  def all_users
    @users = User.all
  end

  def set_layout_info
    @time = Russian::strftime(Time.now, "%d %B %Y, %a, %H:%M")
  end
end
