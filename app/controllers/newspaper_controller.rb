class NewspaperController < ApplicationController
  before_filter :get_popular_tags
  before_action :set_post, only: [:read, :share, :visit_post]
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

  def news_search
    @posts = Post.search(params[:word]).paginate(:page => params[:page], :per_page => 7).to_a
    @posts.insert(rand_position, get_random_advertisement).compact! if @posts.count > 3  # advertisement will not appear if there a few posts on a search page

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def tagged_news
    @posts = Post.tagged_with(params[:tag]).by_position.paginate(:page => params[:page], :per_page => 7).to_a
    @posts.insert(rand_position, get_random_advertisement).compact! if @posts.count > 3  # advertisement will not appear if there a few posts on a tag page

    @tags = Post.related_tags(params[:tag])
  end

  def archived_posts
    @posts = Post.archived_posts(params[:start_date], params[:end_date]).paginate(:page => params[:page], :per_page => 7)
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

  def visit_post
    @post.visits!

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
    ads_num = Option.get_value('ads_num').to_i

    id = session[:adv].select { |k, v| v < ads_num }.keys.sample
    session[:adv][id] += 1

    return Advertisement.find(id) unless id.nil?
    nil
  end

  def set_session
    adv = Advertisement.enabled.pluck(:id)
    session[:adv] ||= Hash.new(0)
    adv.each { |id| session[:adv][id] += 0 }
    session[:adv].delete_if { |k, v| !adv.include?(k) }
  end

  def rand_position
    rand (Post.main.count / 2).to_i
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
