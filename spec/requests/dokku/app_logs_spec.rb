require "rails_helper"

RSpec.describe "Dokku::AppLogs" do
  let(:ssh_key_mock) { instance_double(SshKey) }
  let(:testbox) { instance_double(Dokku::App) }

  before do
    allow(SshKey).to receive(:new).and_return(ssh_key_mock)
    allow(ssh_key_mock).to receive(:accessible?).and_return(true)
    allow(testbox).to receive(:name).and_return("testbox")
    allow(testbox).to receive(:logs).and_return("testbox logs")

    allow(Dokku::App).to receive(:new).and_return(testbox)
  end

  describe "GET /dokku/apps/:app_id/app_logs" do
    subject { get dokku_app_app_logs_path(testbox), headers: basic_authorization_header }

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
      expect(response.body).to include("testbox logs")
    end
  end
end
