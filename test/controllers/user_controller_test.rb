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

  test "should_delete_simple_user" do
    @simple_user = create(:two, email: 'mail@mail.com', username: 'mailmail_com')

    assert_difference('User.count', -1) do
      delete :destroy, id: @simple_user.id
    end

    assert_redirected_to users_url
  end

  test "should_block_deletion_of_admin" do
    @simple_user = create(:one, email: 'mail@mail.com', username: 'mailmail_com')

    assert_difference('User.count', 0) do
      delete :destroy, id: @simple_user.id
    end

    assert_redirected_to users_url
  end

  test "should_block_deletion_for_non_admin_user" do
    sign_out @user
    sign_in create(:editor)
    @simple_user = create(:two, email: 'mail@mail.com', username: 'mailmail_com')

    assert_difference('User.count', 0) do
      delete :destroy, id: @simple_user.id
    end

    assert_redirected_to users_url
  end

  test "should_block_to_drop_admin_rights_for_himself" do
    @admin = create(:admin)

    patch :to_corrector, id: @user.id
    @user = User.find(@user.id)

    assert @user.admin?
    assert_redirected_to users_url
  end

  test "should_block_to_drop_admin_rights_for_himself_to_editor" do
    @admin = create(:admin)

    patch :to_editor, id: @user.id
    @user = User.find(@user.id)

    assert @user.admin?
    assert_redirected_to users_url
  end

  test "should_drop_admin_rights_for_other_admin" do
    @admin = create(:admin)

    patch :to_editor, id: @admin.id
    @admin = User.find(@admin.id)

    assert @admin.editor?
    assert_redirected_to users_url
  end
end
