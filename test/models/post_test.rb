require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @post_one = create(:post_one)
    @post_two = create(:post_two)
    @post_three = create(:post_three)
    @post_four = create(:post_four)
    @post_five = create(:post_five)
    @post_six = create(:post_six)
  end

  test "should_show_next_post" do
    @next_post = @post_one.next
    assert_equal @post_two, @next_post
  end

  test "should_show_prev_post" do
    @prev_post = @post_two.prev
    assert_equal @post_one, @prev_post
  end

  test "should_switch_positions" do
    old_post_one_pos = @post_one.position
    old_post_two_pos = @post_two.position

    @post_one.switch @post_two

    assert_equal @post_one.position, old_post_two_pos
    assert_equal @post_two.position, old_post_one_pos
  end

  test "should_force_post_to_show_on_main_page" do
    assert_difference('Post.main.count', 1) do
      @post_one.main!
    end
    assert @post_one.main
  end

  test "should_hide_post" do
    assert_difference('Post.hidden.count', 1) do
      @post_three.hide!
    end
    assert !@post_three.main
  end

  #test "should_not_remove_existed_position" do
    # same_post = @post_three
    #
    # @post_three.set_position
    #
    # assert @post_three == same_post
  #end

  test "should_make_featured_post" do
    @post_three.featured!

    assert @post_three.featured?
  end

  test "should_defeature_post" do
    @post_four.defeature!

    assert !@post_four.featured?
  end

  test "should_find_post_through_search" do
    found = Post.search(@post_four.title).first

    assert_equal @post_four, found
  end

  test "should_find_four_posts" do
    found = Post.search('MyString').count

    assert_equal found, Post.all.count
  end

  test "should_switch_with_next_main_post" do
    post = @post_four.next_main

    assert_equal post, @post_six
  end

  test "should_switch_with_prev_main_post" do
    post = @post_six.prev_main

    assert_equal post, @post_four
  end

  test "should_remove_feature_flag_on_hidden_post" do
    @post_four.hide!

    assert !@post_four.featured?, "featured - #{@post_four.featured?}"
  end

  test "should_block_make_featured_post_that_hide" do
    @post_two.featured!

    assert !@post_two.featured?, "featured - #{@post_two.featured?}"
  end

  test "should_find_post_with_other_case" do
    post_title = @post_one.title.downcase

    found = Post.search(post_title).first

    assert_equal found, @post_one
  end

  test "should_find_post_with_random_case" do
    post_title = 'mYStRiNg1'

    found = Post.search(post_title).first

    assert_equal found, @post_one
  end
end
