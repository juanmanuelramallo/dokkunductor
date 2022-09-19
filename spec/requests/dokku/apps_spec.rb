require "rails_helper"

RSpec.describe Dokku::AppsController do
  describe "GET /dokku/apps" do
    subject { get dokku_apps_path }


    before do
      allow(Dokku::App).to receive(:all).and_return([
        Dokku::App.new("testbox"),
        Dokku::App.new("applogger")
      ])
    end

    it "renders a collection of apps" do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("testbox")
      expect(response.body).to include("applogger")
    end

    context "without apps deployed" do
      before do
        allow(Dokku::App).to receive(:all).and_return([])
      end

      it "renders a message" do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("You haven't deployed any applications yet")
      end
    end
  end
end
