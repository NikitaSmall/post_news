require 'test_helper'

class AdvertisementTest < ActiveSupport::TestCase
  setup do
    @advertisement = create(:advertisement, enabled: true)
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

  test "should_get_rand_advertisement" do
    second = create(:advertisement, enabled: true)
    third = create(:advertisement, enabled: true)

    record = Advertisement.random

    assert_kind_of Advertisement, record
  end

  test "should_increase_vesets_count" do
    assert_difference('@advertisement.visits', 1) do
      @advertisement.visits!
    end
  end
end
