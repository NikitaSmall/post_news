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
      post :create, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }
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
end
