require 'rails_helper'

RSpec.describe "Advertisements", type: :request do
  describe "GET /advertisements" do
    it "works! (now write some real specs)" do
      get advertisements_path
      expect(response).to have_http_status(200)
    end
  end
end
