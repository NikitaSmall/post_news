require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "should_show_next_post" do
    post_one = posts(:one)
    post_two = posts(:two)

    next_post = post_one.next
    assert_equal post_two, next_post
  end

  test "should_show_prev_post" do
    post_one = posts(:one)
    post_two = posts(:two)

    prev_post = post_two.prev
    assert_equal post_one, prev_post
  end

  test "should_switch_positions" do
    post_one = posts(:one)
    post_two = posts(:three)
    old_post_one_pos = post_one.position
    old_post_two_pos = post_two.position

    post_one.switch post_two

    assert_equal post_one.position, old_post_two_pos
    assert_equal post_two.position, old_post_one_pos
  end

  test "should_force_post_to_show_on_main_page" do
    post = posts(:one)

    assert_difference('Post.main.count', 1) do
      post.main!
    end
    assert post.main
  end

  test "should_hide_post" do
    post = posts(:three)

    assert_difference('Post.hidden.count', 1) do
      post.hide!
    end
    assert !post.main
  end

  test "should_not_remove_existed_position" do
    post = posts(:three)
    same_post = posts(:three)

    post.set_position

    assert post == same_post
  end

  test "should_make_featured_post" do
    post = posts(:one)

    post.featured!

    assert post.featured?
  end

  test "should_defeature_post" do
    post = posts(:four)

    post.defeature!

    assert !post.featured?
  end

  test "should_find_post_through_search" do
    post = posts(:four)

    found = Post.search(post.title).first

    assert_equal post, found
  end

  test "should_find_four_posts" do
    found = Post.search('MyString').count

    assert_equal found, Post.all.count
  end

  test "should_switch_with_next_main_post" do
    main_post = posts(:four)
    next_main_post = posts(:six)

    post = main_post.next_main

    assert_equal post, next_main_post
  end

  test "should_switch_with_prev_main_post" do
    main_post = posts(:six)
    prev_main_post = posts(:four)

    post = main_post.prev_main

    assert_equal post, prev_main_post
  end
end
