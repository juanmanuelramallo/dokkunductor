require "rails_helper"

RSpec.describe Dokku::SshKey do
  let(:command_mock) { instance_double(Ssh) }

  describe ".all" do
    subject { described_class.all }

    let(:result) do
      <<~STR
        SHA256:EwsVuxgqkWjGxRTjYN59z17A18owbJDhEwsSbvAPQ/U NAME="local" SSHCOMMAND_ALLOWED_KEYS="no-agent-forwarding,no-user-rc,no-X11-forwarding,no-port-forwarding"
        SHA256:7b5CPReTZoG4gJhHKaqyoxQlwKDmvNhvB/bFuVHoqzI NAME="dokkunductor" SSHCOMMAND_ALLOWED_KEYS="no-agent-forwarding,no-user-rc,no-X11-forwarding,no-port-forwarding"
      STR
    end

    before do
      allow(Ssh).to receive(:new).and_return(command_mock)
      allow(command_mock).to receive(:exec).and_return(result)
    end

    it "returns all ssh keys" do
      expect(subject).to contain_exactly(
        have_attributes(info: 'SHA256:EwsVuxgqkWjGxRTjYN59z17A18owbJDhEwsSbvAPQ/U NAME="local" SSHCOMMAND_ALLOWED_KEYS="no-agent-forwarding,no-user-rc,no-X11-forwarding,no-port-forwarding"'),
        have_attributes(info: 'SHA256:7b5CPReTZoG4gJhHKaqyoxQlwKDmvNhvB/bFuVHoqzI NAME="dokkunductor" SSHCOMMAND_ALLOWED_KEYS="no-agent-forwarding,no-user-rc,no-X11-forwarding,no-port-forwarding"')
      )
    end
  end
end
