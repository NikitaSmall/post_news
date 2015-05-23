class NewspaperController < ApplicationController
  before_filter :get_popular_tags
  before_action :set_post, only: [:read, :share]
  layout 'application'

  def index
    @posts = Post.main.by_position.to_a # for good flexibility relation turned to array
    @posts.insert(rand_position, get_random_advertisement).compact! if @posts.count > 3  # advertisement will not appear if there a few posts on main page
    @featured_posts = Post.featured.by_position
  end

  def archive
    @posts = Post.hidden.by_position
  end

  def read
    @advertisement = get_random_advertisement
  end

  def share
    @post.shared!

    respond_to do |format|
      format.html { redirect_to read_post_url(@post) }
      format.js {}
    end
  end

  def visit_advertisement
    @advertisement = Advertisement.find(params[:id])
    @advertisement.visits!

    respond_to do |format|
      format.html { redirect_to root_url }
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

  def get_random_advertisement
    set_session

    id = session[:adv].select { |k, v| v < 5 }.keys.sample
    session[:adv][id] += 1

    return Advertisement.find(id) unless id.nil?
    nil
  end

  def set_session
    adv = Advertisement.enabled
    session[:adv] ||= Hash.new(0)
    adv.each { |record| session[:adv][record.id] += 0 }
  end

  def rand_position
    rand (Post.main.count / 2).to_i
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
