require 'test_helper'

class NewspaperControllerTest < ActionController::TestCase
  setup do
    @post = create(:post_one)
    @user = create(:admin, id: 1)
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
end