require 'rails_helper'

RSpec.describe "advertisements/index", type: :view do
  before(:each) do
    assign(:advertisements, [
      Advertisement.create!(
        :title => "Title",
        :content => "Description",
        :enabled => false
      ),
      Advertisement.create!(
        :title => "Title",
        :content => "Description",
        :enabled => false
      )
    ])
  end

  it "renders a list of advertisements" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
