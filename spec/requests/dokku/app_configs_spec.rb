require "rails_helper"

RSpec.describe Dokku::AppConfigsController do
  let(:ssh_key_mock) { instance_double(SshKey) }
  let(:testbox) { instance_double(Dokku::App) }

  before do
    allow(SshKey).to receive(:new).and_return(ssh_key_mock)
    allow(ssh_key_mock).to receive(:accessible?).and_return(true)
    allow(testbox).to receive(:name).and_return("testbox")
    allow(testbox).to receive(:config).and_return({"TEST" => "test", "RAILS_ENV" => "production"})
    allow(Dokku::App).to receive(:new).and_return(testbox)
  end

  describe "GET /apps/:app_id/app_configs" do
    subject { get dokku_app_app_configs_path(testbox.name), headers: basic_authorization_header }

    it "renders the config form" do
      subject

      assert_select "input[name='TEST'][value='test']"
      assert_select "input[name='RAILS_ENV'][value='production']"
    end
  end
end
