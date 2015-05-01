require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @post = create(:post_one)

    @user = create(:one)
    @newbie = create(:newbie)
    @corrector = create(:corrector)
    @author = create(:author)

    @post.user_id = @user.id
    sign_in @user
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
    sign_out @user
    sign_in @newbie

    get :index
    assert_redirected_to root_path
  end

  test "should_block_corrector_on_new" do
    sign_out @user
    sign_in @corrector

    get :new

    assert_redirected_to posts_path
  end

  test "should_block_corrector_on_create" do
    sign_out @user
    sign_in @corrector

    post :create, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }

    assert_redirected_to posts_path
  end

  test "should_create_a_position_for_new_post" do

    sign_out @user
    sign_in @author

    post :create, post: {  user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }
    new_post = Post.order(created_at: :asc).last

    assert_equal new_post.id, new_post.position
    assert_not_nil assigns(:post)
  end

  test "should_block_author_to_edit_other_man_post" do
    sign_out @user
    sign_in @author

    get :edit, id: @post.id
    assert_redirected_to posts_path
  end

  test "should_block_author_to_update_other_man_post" do
    sign_out @user
    sign_in @author

    patch :update, id: @post, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }
    assert_redirected_to posts_path
  end

  test "should_edit_authors_own_post" do
    sign_out @user
    sign_in @author

    # see the fixtures (factory). This post is author ownership
    @post_four = create(:post_four)

    get :edit, id: @post_four.id
    assert_response :success
  end

  test "should_update_authors_own_post" do
    sign_out @user
    sign_in @author
    @post = create(:post_four)

    # see the fixtures. This post is author ownership

    patch :update, id: @post, post: { user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should_switch_two_random_posts" do
    @post_one = @post
    @post_two = create(:post_four)

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
    create(:post_two)

    @post_one = @post
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
    @post_one = create(:post_six)
    old_post_one_pos = @post_one.position

    patch :switch_with_next, first: @post_one.id

    @post_one = Post.find(@post_one.id)

    assert_equal @post_one.position, old_post_one_pos
    assert_redirected_to posts_path
  end

  test "should_switch_with_the_prev" do
    @post_one = create(:post_two)
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
    @post_one = @post
    old_post_one_pos = @post_one.position

    patch :switch_with_prev, first: @post_one.id

    @post_one = Post.find(@post_one.id)

    assert_equal @post_one.position, old_post_one_pos
    assert_redirected_to posts_path
  end

  test "should_make_post_featured" do
    @post_one = create(:post_three)

    patch :feature, id: @post_one
    @post_one = Post.find(@post_one.id)

    assert @post_one.featured?
    assert_redirected_to posts_path
  end

  test "should_make_post_defeatured" do
    @post_one = create(:post_four)

    patch :defeature, id: @post_one
    @post_one = Post.find(@post_one.id)

    assert !@post_one.featured?
    assert_redirected_to posts_path
  end

  test "should_give_position_from_id_on_creation" do
    assert_difference('Post.count') do
      post :create, post: { user_id: @post.user_id, content: "#{@post.content}1", featured: @post.featured, main: @post.main, title: "#{@post.title}1" }
    end

    assert_equal @post.id, @post.position
    assert_redirected_to post_path(assigns(:post))
  end

  test "should_block_corrector_on_deleting" do
    sign_out @user
    sign_in @corrector
    @before = Post.count

    delete :destroy, id: @post
    @after = Post.count

    assert_equal @before, @after
    assert_redirected_to posts_path
  end

  test "should_block_author_on_deleting_other_post" do
    sign_out @user
    sign_in @corrector
    @before = Post.count

    delete :destroy, id: @post
    @after = Post.count

    assert_equal @before, @after
    assert_redirected_to posts_path
  end

  test "should_delete_authors_own_post" do
    sign_out @user
    sign_in @author
    @post = create(:post_four)

    # see the fixtures. This post is author ownership

    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end
    assert_redirected_to posts_path
  end

  test "should_block_corrector_on_switch_actions" do
    sign_out @user
    sign_in @corrector

    @old_p = @post.position

    patch :switch_with_next, first: @post.id
    @post = Post.find(@post.id)
    @new_p = @post.position

    assert_equal @old_p, @new_p
    assert_redirected_to posts_path
  end


  test "should_block_author_on_switch_actions" do
    sign_out @user
    sign_in @author

    @old_p = @post.position

    patch :switch_with_next, first: @post.id
    @post = Post.find(@post.id)
    @new_p = @post.position

    assert_equal @old_p, @new_p
    assert_redirected_to posts_path
  end

  test "should_move_post_to_main" do
    patch :to_main, id: @post.id
    @post = Post.find(@post.id)

    assert @post.main?
    assert_redirected_to posts_path
  end

  test "should_hide_post_from_main" do
    @post = create(:post_four)

    patch :hide, id: @post.id
    @post = Post.find(@post.id)

    assert !@post.main?
    assert_redirected_to posts_path
  end

  test "should_switch_with_the_next_main_post" do
    create(:post_five)
    create(:post_six)

    @post_one = create(:post_four)
    @post_two = @post_one.next_main

    old_post_one_pos = @post_one.position
    old_post_two_pos = @post_two.position

    patch :switch_with_next_main, first: @post_one.id

    @post_one = Post.find(@post_one.id)
    @post_two = Post.find(@post_two.id)

    assert_equal @post_one.position, old_post_two_pos
    assert_equal @post_two.position, old_post_one_pos

    assert_redirected_to main_posts_path
  end

  test "should_switch_with_the_prev_main_post" do
    create(:post_five)
    create(:post_four)

    @post_one = create(:post_six)
    @post_two = @post_one.prev_main

    old_post_one_pos = @post_one.position
    old_post_two_pos = @post_two.position

    patch :switch_with_prev_main, first: @post_one.id

    @post_one = Post.find(@post_one.id)
    @post_two = Post.find(@post_two.id)

    assert_equal @post_one.position, old_post_two_pos
    assert_equal @post_two.position, old_post_one_pos

    assert_redirected_to main_posts_path
  end

  test "should_block_switch_prev_main_post_with_the_first" do
    @post_one = @post
    old_post_one_pos = @post_one.position

    patch :switch_with_prev_main, first: @post_one.id

    @post_one = Post.find(@post_one.id)

    assert_equal @post_one.position, old_post_one_pos
    assert_redirected_to main_posts_path
  end

  test "should_block_switch_next_main_post_with_the_first" do
    @post_one = create(:post_six)
    old_post_one_pos = @post_one.position

    patch :switch_with_next_main, first: @post_one.id

    @post_one = Post.find(@post_one.id)

    assert_equal @post_one.position, old_post_one_pos
    assert_redirected_to main_posts_path
  end
end
