require "rails_helper"

RSpec.describe SshKey, :persist do
  describe "#command" do
    before do
      File.open("./persistent/dokkunductor_id_ed25519.pub", "w") do |file|
        file.puts "mypublickey"
      end
    end

    subject { described_class.new.command }

    it { is_expected.to include "echo \"mypublickey\" | dokku ssh-keys:add dokkunductor" }
  end

  describe "#save" do
    subject { described_class.new.save }

    it "generates a new SSH key" do
      expect { subject }.to change { File.exist?("./persistent/dokkunductor_id_ed25519") }.from(false).to(true)
    end
  end

  describe "#public_key?" do
    before do
      File.open("./persistent/dokkunductor_id_ed25519.pub", "w") do |file|
        file.puts "mypublickey"
      end
    end

    subject { described_class.new.public_key? }

    it { is_expected.to be true }

    context "when the public key does not exist" do
      before do
        File.delete("./persistent/dokkunductor_id_ed25519.pub")
      end

      it { is_expected.to be false }
    end
  end

  describe "#public_key" do
    before do
      File.open("./persistent/dokkunductor_id_ed25519.pub", "w") do |file|
        file.puts "mypublickey"
      end
    end

    subject { described_class.new.public_key }

    it { is_expected.to eq "mypublickey" }
  end

  describe "#accessible?" do
    let(:ssh_key) { described_class.new }

    before do
      allow(ssh_key).to receive(:ssh).and_return(`exit 1`)
    end

    subject { ssh_key.accessible? }

    it { is_expected.to be false }

    context "when the SSH key is accessible" do
      before do
        allow(ssh_key).to receive(:ssh).and_return(`exit 0`)
      end

      it { is_expected.to be true }
    end
  end

  describe "#destroy" do
    before do
      File.open("./persistent/dokkunductor_id_ed25519.pub", "w") do |file|
        file.puts "mypublickey"
      end
    end

    subject { described_class.new.destroy }

    it "removes the SSH key" do
      expect { subject }.to change { File.exist?("./persistent/dokkunductor_id_ed25519.pub") }.from(true).to(false)
    end
  end
end
