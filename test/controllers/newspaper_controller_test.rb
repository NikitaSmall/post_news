require 'test_helper'

class NewspaperControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @post = create(:post_one, main: true)
    @user = create(:admin, id: 1)
    @option = create(:option, name: 'ads_num', value: '1')
  end

  test "should_get_index" do
    get :index

    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should_get_read_post" do
    get :read, id: @post.id

    assert_response :success
  end

  test "should_update_post_shared_number" do
    assert_difference('@post.shared', 1) do
      post :share, id: @post
      @post = Post.find(@post.id)
    end

    assert_redirected_to read_post_url(@post)
  end

  test "should_get_read_post_with_advertisement" do
    @advertisement = create(:advertisement, enabled: true)
    get :read, id: @post.id

    assert_response :success
    assert_select 'div#advertisement a'
  end

  test "should_get_index_with_few_posts_and_without_advertisement" do
    @advertisement = create(:advertisement, enabled: true)

    get :index

    assert_response :success
    assert_not_nil assigns(:posts)

    assert_select 'a.news-item', 1
  end

  test "should_get_undex_with_lot_of_posts_and_advertisement" do
    @advertisement = create(:advertisement, enabled: true)
    second = create(:post_two, main: true)
    three = create(:post_three, main: true)
    four = create(:post_four, main: true)

    get :index

    assert_response :success
    assert_not_nil assigns(:posts)

    assert_select 'a.news-item', 5
  end

  test "should_get_undex_with_lot_of_posts_and_advertisement_a_lot_of_times" do
    @advertisement = create(:advertisement, enabled: true)
    second = create(:post_two, main: true)
    three = create(:post_three, main: true)
    four = create(:post_four, main: true)

    10.times { get :index }

    assert_response :success
  end

  test "should_increase_advertisement_visits_count" do
    @advertisement = create(:advertisement, enabled: true)

    post :visit_advertisement, id: @advertisement.id
    new = Advertisement.find(@advertisement.id)

    assert_equal new.visits, @advertisement. visits + 1
  end

  test "should_increase_post_visits_count" do
    post :visit_post, id: @post.id
    new = Post.find(@post.id)

    assert_equal new.visits, @post.visits + 1
  end

  test "should_show_search_result" do
    get :news_search, word: 'Str'
    assert_response :success
  end

  test "should_show_correct_number_at_advertisment_state_changing" do
    @advertisement = create(:advertisement, enabled: true)
    second = create(:post_two, main: true)
    three = create(:post_three, main: true)
    four = create(:post_four, main: true)

    get :index
    Advertisement.delete_all
    get :index

    assert_select 'a.news-item', 4
  end

  test "should_show_read_tag_page" do
    @tagged_one = create(:post_one, title: 'TaggedString1', tag_list: 'tag, test', id: 7)
    @tagged_two = create(:post_one, title: 'TaggedString2', tag_list: 'test', id: 8)

    get :tagged_news, tag: 'test'
    assert_response :success

    assert_select 'a.item-result', 2
  end

  test "should_show_read_tag_page_with_advertisment" do
    @tagged_one = create(:post_one, title: 'TaggedString1', tag_list: 'tag, test', id: 7)
    @tagged_two = create(:post_one, title: 'TaggedString2', tag_list: 'test', id: 8)
    @tagged_three = create(:post_one, title: 'TaggedString3', tag_list: 'tag, test', id: 9)
    @tagged_four = create(:post_one, title: 'TaggedString4', tag_list: 'test', id: 10)
    @advertisement = create(:advertisement, enabled: true)

    get :tagged_news, tag: 'test'
    assert_response :success

    assert_select 'a.item-result', 5
  end

  test "should_show_archived_posts" do
    @post_one = create(:post_one, title: 'TaggedString1', tag_list: 'tag, test', id: 7)
    @post_two = create(:post_one, title: 'TaggedString2', tag_list: 'test', id: 8)

    get :archived_posts, start_date: 1.day.ago.to_s, end_date: Date.today.to_s
    assert_response :success

    assert_select 'a.item-result', 3
  end

  test "should_show_archived_posts_with_advertisment" do
    @post_one = create(:post_one, title: 'TaggedString1', tag_list: 'tag, test', id: 7)
    @post_two = create(:post_one, title: 'TaggedString2', tag_list: 'test', id: 8)
    @tagged_three = create(:post_one, title: 'TaggedString3', tag_list: 'tag, test', id: 9)
    @tagged_four = create(:post_one, title: 'TaggedString4', tag_list: 'test', id: 10)
    @advertisement = create(:advertisement, enabled: true)

    get :archived_posts, start_date: 1.day.ago.to_s, end_date: Date.today.to_s
    assert_response :success

    assert_select 'a.item-result', 6
  end
end