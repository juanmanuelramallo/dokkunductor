require "rails_helper"

RSpec.describe Dokku::PostgresLinksController do
  let(:service) { Dokku::Postgres.new(service: "applogger_production") }

  before do
    allow(Dokku::Postgres).to receive(:new).and_return(service)
    allow(service).to receive(:links).and_return(["applogger", "facebook"])
    allow(Dokku::App).to receive(:all).and_return([
      Dokku::App.new(name: "twitter"),
      Dokku::App.new(name: "facebook"),
      Dokku::App.new(name: "applogger")
    ])
  end

  describe "GET /dokku/postgres/:postgre_service/postgres_links/new" do
    subject { get new_dokku_postgre_links_path(service), headers: basic_authorization_header }

    it "renders a form to link a postgres service to an app" do
      subject
      expect(response).to have_http_status(:ok)
      assert_select "option", "twitter"
      assert_select "option", {count: 0, text: "facebook"}
      assert_select "option", {count: 0, text: "applogger"}
    end
  end

  describe "POST /dokku/postgres/:postgre_service/postgres_links" do
    subject { post dokku_postgre_links_path(service), params: params, headers: basic_authorization_header }

    let(:params) do
      {
        postgres_link: {
          app_name: "twitter"
        }
      }
    end

    before do
      allow(service).to receive(:link).and_return(true)
    end

    it "links the postgres service to the app" do
      expect(service).to receive(:link).with("twitter")
      subject
      expect(response).to redirect_to dokku_postgre_path(service)
    end
  end
end
