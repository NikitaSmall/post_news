require 'test_helper'

class AdvertisementTest < ActiveSupport::TestCase
  setup do
    @advertisement = create(:advertisement)
  end

  test "should_make_enabled_advertisement" do
    @advertisement.enabled!

    assert @advertisement.enabled
  end

  test "should_make_disabled_advertisement" do
    @advertisement.enabled! # make this enabled
    @advertisement.disabled!

    assert !@advertisement.enabled
  end
end
