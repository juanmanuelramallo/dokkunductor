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

      assert_select "input[name='config[TEST]'][value='test']"
      assert_select "input[name='config[RAILS_ENV]'][value='production']"
    end
  end

  describe "PUT /apps/:app_id/app_configs" do
    subject { put dokku_app_app_configs_path(testbox.name), params: params, headers: basic_authorization_header }

    let(:params) do
      {
        config: {
          "TEST" => "test2",
          "RAILS_ENV" => "development",
          "NEW_CONFIG" => "new"
        }
      }
    end

    it "updates the config" do
      expect(testbox).to receive(:update_config).with(include(params[:config].to_h)).and_return(true)

      subject

      expect(response).to redirect_to dokku_app_app_configs_path(testbox.name)
    end
  end
end
