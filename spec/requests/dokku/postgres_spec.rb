require "rails_helper"

RSpec.describe Dokku::PostgresController do
  let(:ssh_key_mock) { instance_double(SshKey) }

  let(:testbox) { Dokku::Postgres.new(service: "testbox") }
  let(:applogger) { Dokku::Postgres.new(service: "applogger") }

  before do
    allow(SshKey).to receive(:new).and_return(ssh_key_mock)
    allow(ssh_key_mock).to receive(:accessible?).and_return(true)

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
      allow(Ssh).to receive(:new).and_return(SshMock::Success.new("testbox info"))
    end

    it "renders a single postgres service" do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("testbox")
      expect(response.body).to include("testbox info")
    end
  end
end
