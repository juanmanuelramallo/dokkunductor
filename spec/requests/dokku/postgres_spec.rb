require "rails_helper"

RSpec.describe Dokku::PostgresController do
  let(:ssh_key_mock) { instance_double(SshKey) }

  let(:testbox) { instance_double(Dokku::Postgres) }
  let(:applogger) { instance_double(Dokku::Postgres) }

  before do
    allow(SshKey).to receive(:new).and_return(ssh_key_mock)
    allow(ssh_key_mock).to receive(:accessible?).and_return(true)

    allow(testbox).to receive(:service).and_return("testbox")
    allow(applogger).to receive(:service).and_return("applogger")

    allow(Dokku::Postgres).to receive(:all).and_return([
      testbox,
      applogger
    ])
  end

  describe "GET /dokku/postgres" do
    subject { get dokku_postgres_path, headers: basic_authorization_header }

    it "renders a collection of postgres services" do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("testbox")
      expect(response.body).to include("applogger")
    end
  end

  describe "GET /dokku/postgres/:service" do
    subject { get dokku_postgre_path(service), headers: basic_authorization_header }

    let(:service) { "testbox" }

    before do
      allow(Dokku::Postgres).to receive(:new).and_return(testbox)
      allow(testbox).to receive(:info).and_return("testbox info")
    end

    it "renders a single postgres service" do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("testbox")
      expect(response.body).to include("testbox info")
    end
  end

  describe "POST /dokku/postgres/" do
    subject { post dokku_postgres_path, params: params, headers: basic_authorization_header }

    let(:another_production) { instance_double(Dokku::Postgres) }

    let(:params) do
      {
        dokku_postgres: {
          service: "another_production"
        }
      }
    end

    before do
      allow(Dokku::Postgres).to receive(:new).and_return(another_production)
      allow(another_production).to receive(:save).and_return(true)
      allow(another_production).to receive(:service).and_return("another_production")
    end

    it "creates a new postgres service" do
      subject
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(dokku_postgre_path("another_production"))
    end
  end
end
