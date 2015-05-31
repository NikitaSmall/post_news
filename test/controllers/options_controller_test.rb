require 'test_helper'

class OptionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = create(:admin)
    sign_in @user
  end

  test "should_get_index" do
    get :index

    assert_response :success
    assert_not_nil assigns(:options)
  end

  test "should_set_value" do
    patch :set_option, name: 'num', value: '42'
    option = Option.get_value('num').to_i

    assert_equal option, 42
    assert_redirected_to options_url
  end
end
