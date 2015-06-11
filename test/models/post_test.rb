require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @post_one = create(:post_one)
    @post_two = create(:post_two)
    @post_three = create(:post_three)
    @post_four = create(:post_four)
    @post_five = create(:post_five)
    @post_six = create(:post_six)

    @option = create(:option, name: 'tag_count', value: 2)
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

  test "should_find_by_tag" do
    @tagged = create(:post_one, title: 'TaggedString', tag_list: 'tag, test', id: 7)

    @found = Post.tagged_with('tag')

    assert_equal @tagged, @found.first
  end

  test "should_find_most_popular_tag" do
    @tagged_one = create(:post_one, title: 'TaggedString1', tag_list: 'tag, test', id: 7)
    @tagged_two = create(:post_one, title: 'TaggedString2', tag_list: 'test', id: 8)
    @tagged_three = create(:post_one, title: 'TaggedString3', tag_list: 'tag', id: 9)
    @tagged_four = create(:post_one, title: 'TaggedString4', tag_list: 'tag', id: 10)
    @tagged_five = create(:post_one, title: 'TaggedString5', tag_list: 'another', id: 11)

    @popular_tags = Post.popular_tags(2)

    assert_equal @popular_tags.first.name, 'tag'
    assert_equal @popular_tags.last.name, 'test'
  end

  test "should_find_most_tagged_posts" do
    @tagged_one = create(:post_one, title: 'TaggedString1', tag_list: 'tag, test', id: 7)
    @tagged_two = create(:post_one, title: 'TaggedString2', tag_list: 'test', id: 8)
    @tagged_three = create(:post_one, title: 'TaggedString3', tag_list: 'tag', id: 9)
    @tagged_four = create(:post_one, title: 'TaggedString4', tag_list: 'tag', id: 10)
    @tagged_five = create(:post_one, title: 'TaggedString5', tag_list: 'another', id: 11)

    @popular_posts = Post.popular_tagged_post(2)

    assert_equal @popular_posts.first, @tagged_one
    assert_equal @popular_posts.last, @tagged_three
  end

  test "should_return_my_posts" do
    @user = create(:one)

    @my_posts = Post.user_posts(@user)

    assert_equal @my_posts.count, 5
  end

  test "should_create_new_post_with_zero_shares" do
    post = create(:post_one, title: 'Str1', id: 7)

    assert_equal post.shared, 0
  end

  test "should_rise_shared_count_by_one" do
    assert_difference('@post_one.shared', 1) do
      @post_one.shared!
    end
  end

  test "should_rise_counter_by_one" do
    assert_difference('@post_one.visits', 1) do
      @post_one.visits!
    end
  end

  test "should_return_related_tag" do
    @tagged_one = create(:post_one, title: 'TaggedString1', tag_list: 'tag, test, repo', id: 7)
    @tagged_two = create(:post_one, title: 'TaggedString2', tag_list: 'test, tag', id: 8)
    @tagged_three = create(:post_one, title: 'TaggedString3', tag_list: 'tag, test', id: 9)
    @tagged_four = create(:post_one, title: 'TaggedString4', tag_list: 'tag', id: 10)

    tag_name = Post.related_tags('test').first

    assert_equal tag_name, 'tag'
  end

  test "should_return_fresh_post" do
    post = Post.archived_posts 2.day.ago.to_s, Time.now.to_s

    # most fresh post is @post_one - it is created firstly at each test
    assert_equal post.first, @post_one
  end

  test "should_return_fresh_post_with_empty_param" do
    post = Post.archived_posts 2.day.ago.to_s, ''

    # most fresh post is @post_one - it is created firstly at each test
    assert_equal post.first, @post_one
  end

  test "should_return_fresh_post_with_empty_params" do
    post = Post.archived_posts '', ''

    # most fresh post is @post_one - it is created firstly at each test
    assert_equal post.first, @post_one
  end
end
