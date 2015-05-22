require 'rails_helper'

RSpec.describe "advertisements/new", type: :view do
  before(:each) do
    assign(:advertisement, Advertisement.new(
      :title => "MyString",
      :content => "MyString",
      :enabled => false
    ))
  end

  it "renders new advertisement form" do
    render

    assert_select "form[action=?][method=?]", advertisements_path, "post" do

      assert_select "input#advertisement_title[name=?]", "advertisement[title]"

      assert_select "input#advertisement_description[name=?]", "advertisement[description]"

      assert_select "input#advertisement_enabled[name=?]", "advertisement[enabled]"
    end
  end
end
