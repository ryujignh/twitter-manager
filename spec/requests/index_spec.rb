require 'rails_helper'

RSpec.describe "Index", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get '/'
      expect(response).to have_http_status(200)
    end
  end
end
