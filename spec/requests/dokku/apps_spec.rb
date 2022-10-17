require "rails_helper"

RSpec.describe Dokku::AppsController do
  let(:ssh_key_mock) { instance_double(SshKey) }

  before do
    allow(SshKey).to receive(:new).and_return(ssh_key_mock)
    allow(ssh_key_mock).to receive(:accessible?).and_return(true)

    allow(Dokku::App).to receive(:all).and_return([
      Dokku::App.new(name: "testbox"),
      Dokku::App.new(name: "applogger")
    ])
  end

  describe "GET /dokku/apps" do
    subject { get dokku_apps_path, headers: basic_authorization_header }

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

  describe "POST /dokku/apps" do
    subject { post dokku_apps_path, params: params, headers: basic_authorization_header }

    let(:params) do
      {
        dokku_app: {
          name: "testbox"
        }
      }
    end

    it "creates a new app" do
      expect(Dokku::App).to receive(:create).with(name: "testbox").and_return(Dokku::App.new(name: "testbox"))
      subject

      expect(response).to redirect_to(dokku_apps_path)
    end

    context "when it fails to create the app" do
      it "renders the form again" do
        app = Dokku::App.new(name: "testbox")
        app.errors.add(:base, :invalid, message: "! Invalid name")

        expect(Dokku::App).to receive(:create).with(name: "testbox").and_return(app)
        subject

        expect(response).to have_http_status(:see_other)
        expect(response.body).to include("! Invalid name")
      end
    end
  end
end
