require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include ActionDispatch::TestProcess
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
    photo = fixture_file_upload('missing.png', 'image/png')
    assert_difference('Post.count') do
      post :create, post: { user_id: @post.user_id, content: "#{@post.content}1", featured: @post.featured, main: @post.main, title: "#{@post.title}1", photo: photo }
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

    photo = fixture_file_upload('missing.png', 'image/png')

    post :create, post: {  user_id: @post.user_id, content: @post.content, featured: @post.featured, main: @post.main, title: @post.title, photo: photo }
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
    photo = fixture_file_upload('missing.png', 'image/png')
    assert_difference('Post.count') do
      post :create, post: { user_id: @post.user_id, content: "#{@post.content}1", featured: @post.featured, main: @post.main, title: "#{@post.title}1", photo: photo }
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
    sign_in @author
    @before = Post.count

    delete :destroy, id: @post
    @after = Post.count

    assert_equal @before, @after
    assert_redirected_to posts_path
  end


  #test "should_block_corrector_on_switch_actions" do
  #  sign_out @user
  #  sign_in @corrector
  #
  #  @old_p = @post.position
  #
  #  patch :switch_with_next, first: @post.id
  #  post = Post.find(@post.id)
  #  @new_p = post.position
  #
  #  assert_equal @old_p, @new_p
  #  assert_redirected_to posts_path
  #end


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

  test "should_make_defeatured_when_create_hidden_featured_post" do
    Post.delete_all
    photo = fixture_file_upload('missing.png', 'image/png')

    assert_difference('Post.count') do
      post :create, post: { user_id: @post.user_id, content: "#{@post.content}1", featured: true, main: false, title: "#{@post.title}1", photo: photo }
    end
    post = Post.all.first

    assert !post.featured
    assert_redirected_to post_path(assigns(:post))
  end

  test "should_block_corrector_on_featuring_post" do
    sign_out @user
    sign_in @corrector
    @post = create(:post_three)

    patch :feature, id: @post
    @post = Post.find(@post.id)

    assert !@post.featured, "featured - #{@post.featured?}"
    assert_redirected_to posts_path
  end

  test "should_block_corrector_on_defeaturing_post" do
    sign_out @user
    sign_in @corrector
    @post = create(:post_four)

    patch :defeature, id: @post
    @post = Post.find(@post.id)

    assert @post.featured, "featured - #{@post.featured?}"
    assert_redirected_to posts_path
  end

  test "should_block_corrector_on_moving_post_to_main_page" do
    sign_out @user
    sign_in @corrector

    @post
    patch :to_main, id: @post
    @post = Post.find(@post.id)

    assert !@post.main, "main - #{@post.main}"
    assert_redirected_to posts_path
  end

  test "should_block_corrector_on_hiding_post" do
    sign_out @user
    sign_in @corrector
    @post = create(:post_four)

    patch :hide, id: @post
    @post = Post.find(@post.id)

    assert @post.main, "main - #{@post.main}"
    assert_redirected_to posts_path
  end

  test "should_block_switch_next_main_with_author" do
    @post_four = create(:post_four)
    @post_six = create(:post_six)
    sign_out @user
    sign_in @author

    old_pos_four = @post_four.position
    old_pos_six = @post_six.position

    patch :switch_with_next_main, first: @post_four
    @post_four = Post.find(@post_four.id)
    @post_six = Post.find(@post_six.id)

    assert_equal old_pos_four, @post_four.position
    assert_equal old_pos_six, @post_six.position
  end

  test "should return_not_empty_result_on_pagination_after_last_page_for_posts_hidden" do
    get :hidden, page: '3'

    assert_response :success
    assert_select 'td a'
  end


  test "should return_not_empty_result_on_pagination_after_last_page_for_posts_index" do
    get :index, page: '3'

    assert_response :success
    assert_select 'td a'
  end

  test "should return_not_empty_result_on_pagination_after_last_page_for_posts_search" do
    get :index, word: 'S', page: '3'

    assert_response :success
    assert_select 'td a'
  end

  test "should_get_my_posts_page" do
    get :my_posts

    assert_response :success
    assert_select 'td a'
  end

  test "should_get_empty_my_posts_page_for corrector" do
    sign_out @user
    sign_in @corrector

    get :my_posts

    assert_response :success
    assert_select 'td a', 0
  end

  test "should_get_not_empty_my_posts_page_on_pagination_after_last_page" do
    get :my_posts, page: '3'

    assert_response :success
    assert_select 'td a'
  end


  test "should_create_only_one_post_and_did not update" do
    @post_two = create(:post_two)
    patch :update, id: @post_two, post: { title: @post.title.downcase }
    @p = Post.find(@post_two.id)

    assert_equal @p.title, @post_two.title
  end
end
