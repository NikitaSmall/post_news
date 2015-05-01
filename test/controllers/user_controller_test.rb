require 'test_helper'

class UserControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user = create(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get view" do
    get :view, id: @user
    assert_response :success
  end

  test "should_promote_user_to_corrector" do
    user = create(:two)
    patch :to_corrector, id: user.id
    user = User.find(user.id)

    assert user.corrector?
    assert_redirected_to users_url
  end

  test "should_promote_user_to_author" do
    user = create(:two)
    patch :to_author, id: user.id
    user = User.find(user.id)

    assert user.author?
    assert_redirected_to users_url
  end

  test "should_promote_user_to_editor" do
    user = create(:two)
    patch :to_editor, id: user.id
    user = User.find(user.id)

    assert user.editor?
    assert_redirected_to users_url
  end

  test "should_promote_user_to_admin" do
    user = create(:two)
    patch :to_admin, id: user.id
    user = User.find(user.id)

    assert user.admin?
    assert_redirected_to users_url
  end

  test "should_block_promotion_if_user_is_not_admin" do
    sign_out @user
    user = create(:editor)
    sign_in user

    patch :to_admin, id: user.id
    user = User.find(user.id)

    assert !user.admin?
    assert_redirected_to users_url
  end
end
