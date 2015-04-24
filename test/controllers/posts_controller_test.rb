require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @post = posts(:one)
    @post.user_id = users(:one).id
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: { user_id: @post.user_id, content: "#{@post.content}1", featured: @post.featured, main: @post.main, title: "#{@post.title}1" }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    patch :update, id: @post, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end

  test "should_block_newbie_user" do
    sign_out users(:one)
    sign_in users(:two)

    get :index
    assert_redirected_to root_path
  end

  test "should_block_corrector_on_new" do
    sign_out users(:one)
    sign_in users(:corrector)

    get :new

    assert_redirected_to posts_path
  end

  test "should_block_corrector_on_create" do
    sign_out users(:one)
    sign_in users(:corrector)

    post :create, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }

    assert_redirected_to posts_path
  end

  test "should_create_a_position_for_new_post" do
    sign_out users(:one)
    sign_in users(:author)

    post :create, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }
    assert_not_nil assigns(:post)
  end

  test "should_block_author_to_edit_other_man_post" do
    sign_out users(:one)
    sign_in users(:author)

    get :edit, id: posts(:one).id
    assert_redirected_to posts_path
  end

  test "should_block_author_to_update_other_man_post" do
    sign_out users(:one)
    sign_in users(:author)

    patch :update, id: @post, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }
    assert_redirected_to posts_path
  end

  test "should_edit_authors_own_post" do
    sign_out users(:one)
    sign_in users(:author)

    # see the fixtures. This post is author ownership

    get :edit, id: posts(:four).id
    assert_response :success
  end

  test "should_update_authors_own_post" do
    sign_out users(:one)
    sign_in users(:author)
    @post = posts(:four)

    # see the fixtures. This post is author ownership

    patch :update, id: @post, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should_switch_two_random_posts" do
    @post_one = posts(:one)
    @post_two = posts(:four)

    old_post_one_pos = @post_one.position
    old_post_two_pos = @post_two.position

    patch :switch, first: @post_one.id, second: @post_two.id

    # hard to understand this point. We need to check the new version of the record to get actual information.
    @post_one = Post.find(@post_one.id)
    @post_two = Post.find(@post_two.id)

    assert_equal @post_one.position, old_post_two_pos
    assert_equal @post_two.position, old_post_one_pos

    assert_redirected_to posts_path
  end

  test "should_switch_with_the_next" do
    @post_one = posts(:one)
    @post_two = @post_one.next

    old_post_one_pos = @post_one.position
    old_post_two_pos = @post_two.position

    patch :switch_with_next, first: @post_one.id

    @post_one = Post.find(@post_one.id)
    @post_two = Post.find(@post_two.id)

    assert_equal @post_one.position, old_post_two_pos
    assert_equal @post_two.position, old_post_one_pos

    assert_redirected_to posts_path
  end

  test "should_block_switch_next_with_the_last" do
    @post_one = posts(:four)
    old_post_one_pos = @post_one.position

    patch :switch_with_next, first: @post_one.id

    @post_one = Post.find(@post_one.id)

    assert_equal @post_one.position, old_post_one_pos
    assert_redirected_to posts_path
  end

  test "should_switch_with_the_prev" do
    @post_one = posts(:two)
    @post_two = @post_one.prev

    old_post_one_pos = @post_one.position
    old_post_two_pos = @post_two.position

    patch :switch_with_prev, first: @post_one.id

    @post_one = Post.find(@post_one.id)
    @post_two = Post.find(@post_two.id)

    assert_equal @post_one.position, old_post_two_pos
    assert_equal @post_two.position, old_post_one_pos

    assert_redirected_to posts_path
  end

  test "should_block_switch_prev_with_the_first" do
    @post_one = posts(:one)
    old_post_one_pos = @post_one.position

    patch :switch_with_prev, first: @post_one.id

    @post_one = Post.find(@post_one.id)

    assert_equal @post_one.position, old_post_one_pos
    assert_redirected_to posts_path
  end

  test "should_make_post_featured" do
    @post_one = posts(:one)

    patch :feature, id: @post_one
    @post_one = Post.find(@post_one.id)

    assert @post_one.featured?
    assert_redirected_to posts_path
  end

  test "should_make_post_defeatured" do
    @post_one = posts(:four)

    patch :defeature, id: @post_one
    @post_one = Post.find(@post_one.id)

    assert !@post_one.featured?
    assert_redirected_to posts_path
  end
end
