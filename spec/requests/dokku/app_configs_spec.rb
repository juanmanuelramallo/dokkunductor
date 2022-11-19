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

      assert_select "input[name='config[[1][name]]'][value='TEST']"
      assert_select "input[name='config[[1][value]]'][value='test']"
      assert_select "input[name='config[[1][delete]]'][value='0']"
      assert_select "input[name='config[[2][name]]'][value='RAILS_ENV']"
      assert_select "input[name='config[[2][value]]'][value='production']"
      assert_select "input[name='config[[2][delete]]'][value='0']"
    end
  end

  describe "PUT /apps/:app_id/app_configs" do
    subject { put dokku_app_app_configs_path(testbox.name), params: params, headers: basic_authorization_header }

    let(:params) do
      {
        config: {
          "1" => {"name" => "TEST", "value" => "test2", "delete" => "1"},
          "2" => {"name" => "RAILS_ENV", "value" => "development", "delete" => "0"},
          "0" => {"name" => "NEW_CONFIG", "value" => "new", "delete" => "0"}
        }
      }
    end

    it "updates the config" do
      expect(testbox).to receive(:update_config).with(include(
        "RAILS_ENV" => "development",
        "NEW_CONFIG" => "new"
      )).and_return(true)

      expect(testbox).to receive(:unset_config).with(contain_exactly("TEST")).and_return(true)

      subject

      expect(response).to redirect_to dokku_app_app_configs_path(testbox.name)
    end
  end
end
