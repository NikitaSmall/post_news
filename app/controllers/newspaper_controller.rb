class NewspaperController < ApplicationController

  def index
    @posts = Post.main.by_position
  end

  def archive
    @posts = Post.hidden.by_position
  end

  def all
    @posts = Post.all.by_position
  end
end
