require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end
  # test unit-tests for work starts
  test "should_make_user_admin" do
    assert_difference('@user.rank', 4) do
      @user.admin!
    end
  end

  test "should_make_user_editor" do
    assert_difference('@user.rank', 3) do
      @user.editor!
    end
  end

  test "should_make_user_author" do
    assert_difference('@user.rank', 2) do
      @user.author!
    end
  end

  test "should_make_user_corrector" do
    assert_difference('@user.rank', 1) do
      @user.corrector!
    end
  end

  test "should_"

end
