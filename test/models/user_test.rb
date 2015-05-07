require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = create(:two, email: 'foo@mail.com', username: 'nameless')
    @user = create(:two)
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

  test "should_be_a_user-newbie" do
    assert @user.newbie?
  end

  test "should_be_an_admin_when_alone" do
    User.delete_all

    User.create username: 'user', email: 'exp@mail.ru', password: '1234567890', password_confirmation: '1234567890'
    @user = User.all.first

    assert @user.admin?
  end

  # Этот тест проверяет, может ли последний админ лишить прав сам себя (не должен)
  test "should_protect_alone_admin_from_smaller_rights" do
    User.delete_all

    User.create username: 'user', email: 'exp@mail.ru', password: '1234567890', password_confirmation: '1234567890'
    @user = User.all.first

    @user.corrector!

    assert @user.admin?
  end

  test "should_save_admin_from_deleting" do
    @admin = create(:admin)
    old_count = User.count

    @admin.destroy
    count = User.count

    assert_equal old_count, count
  end
end
