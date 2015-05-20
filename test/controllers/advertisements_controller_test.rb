require 'test_helper'

class AdvertisementsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @advertisement = create(:advertisement)
    @user = create(:one)

    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advertisements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advertisement" do
    photo = fixture_file_upload('missing.png', 'image/png')
    assert_difference('Advertisement.count') do
      post :create, advertisement: { description: "#{@advertisement.description}1", enabled: @advertisement.enabled, title: "#{@advertisement.title}2", photo: photo }
    end

    assert_redirected_to advertisement_path(assigns(:advertisement))
  end

  test "should show advertisement" do
    get :show, id: @advertisement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @advertisement
    assert_response :success
  end

  test "should update advertisement" do
    patch :update, id: @advertisement, advertisement: { description: @advertisement.description, enabled: @advertisement.enabled, title: @advertisement.title }
    assert_redirected_to advertisement_path(assigns(:advertisement))
  end

  test "should destroy advertisement" do
    assert_difference('Advertisement.count', -1) do
      delete :destroy, id: @advertisement
    end

    assert_redirected_to advertisements_path
  end

  test "should_enable_advertisement" do
    patch :enable, id: @advertisement
    @advertisement = Advertisement.find(@advertisement.id)

    assert_redirected_to advertisements_path
    assert @advertisement.enabled
  end

  test "should_disable_advertisement" do
    @adv = create(:advertisement, enabled: true)

    patch :disable, id: @adv
    @advertisement = Advertisement.find(@advertisement.id)

    assert_redirected_to advertisements_path
    assert !@advertisement.enabled
  end
end
