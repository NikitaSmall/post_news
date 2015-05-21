class NewspaperController < ApplicationController
  before_filter :get_popular_tags
  before_action :set_post, only: [:read, :share]
  layout 'application'

  def index
    @posts = Post.main.by_position.to_a.insert(rand_position, get_random_advertisement) # for good flexibility relation turned to array
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
    advertisement = Advertisement.random
    # advertisement = Advertisement.random while bothered?(advertisement) && !tired?
    # tired? ? nil : advertisement
  end

  def bothered?(adv)
    session[:adv] ||= Hash.new(0)
    session[:adv][adv.id] += 1
    return true if session[:adv][adv.id] > 4
    false
  end

  def tired?
    sum = 0
    session[:adv].each { |i, x| sum += x }
    sum >= (5 * Advertisement.enabled.count + 1)
  end

  def rand_position
    rand (Post.main.count / 2).to_i
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
