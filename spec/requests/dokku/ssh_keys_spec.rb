require "rails_helper"

RSpec.describe Dokku::SshKeysController do
  let(:ssh_key_mock) { instance_double(SshKey) }

  let(:local_key) { Dokku::SshKey.new(info: 'SHA256:EwsVuxgqkWjGxRTjYN59z17A18owbJDhEwsSbvAPQ/U NAME="local" SSHCOMMAND_ALLOWED_KEYS="no-agent-forwarding,no-user-rc,no-X11-forwarding,no-port-forwarding"') }

  before do
    allow(SshKey).to receive(:new).and_return(ssh_key_mock)
    allow(ssh_key_mock).to receive(:accessible?).and_return(true)
  end

  describe "GET /dokku/ssh_keys" do
    subject { get dokku_ssh_keys_path, headers: basic_authorization_header }

    before do
      allow(Dokku::SshKey).to receive(:all).and_return([local_key])
    end

    it "returns all ssh keys" do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(local_key.info)
    end
  end
end
