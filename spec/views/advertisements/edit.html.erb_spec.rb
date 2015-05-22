require 'rails_helper'

RSpec.describe "advertisements/edit", type: :view do
  before(:each) do
    @advertisement = assign(:advertisement, Advertisement.create!(
      :title => "MyString",
      :content => "MyString",
      :enabled => false
    ))
  end

  it "renders the edit advertisement form" do
    render

    assert_select "form[action=?][method=?]", advertisement_path(@advertisement), "post" do

      assert_select "input#advertisement_title[name=?]", "advertisement[title]"

      assert_select "input#advertisement_description[name=?]", "advertisement[description]"

      assert_select "input#advertisement_enabled[name=?]", "advertisement[enabled]"
    end
  end
end
