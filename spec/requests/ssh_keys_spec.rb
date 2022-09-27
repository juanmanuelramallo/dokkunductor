require "rails_helper"

RSpec.describe SshKeysController, :persist do
  let(:ssh_key_mock) { SshKey.new }

  before do
    allow(SshKey).to receive(:new).and_return(ssh_key_mock)
    allow(ssh_key_mock).to receive(:accessible?).and_return(false)
    allow(ssh_key_mock).to receive(:command).and_call_original
    allow(ssh_key_mock).to receive(:public_key).and_call_original
    allow(ssh_key_mock).to receive(:public_key?).and_call_original
    allow(ssh_key_mock).to receive(:save).and_call_original
  end

  describe "GET /ssh_key" do
    subject { get ssh_key_path }

    it "redirects to the new SSH key page" do
      subject

      expect(response).to redirect_to(new_ssh_key_path)
    end

    context "when the ssh key already exists" do
      before do
        File.open("./persistent/dokkunductor_id_ed25519_dokku.me.pub", "w") do |file|
          file.puts "mypublickey"
        end
      end

      it "shows the ssh key command" do
        subject

        expect(response.body).to include("mypublickey")
      end
    end

    context "when the ssh keys is already added to Dokku" do
      before do
        allow(ssh_key_mock).to receive(:public_key?).and_return(true)
        allow(ssh_key_mock).to receive(:accessible?).and_return(true)
      end

      it "redirects to the Dokku apps page" do
        subject

        expect(response).to redirect_to(dokku_apps_path)
      end
    end
  end

  describe "GET /ssh_key/new" do
    subject { get new_ssh_key_path }

    it "shows the new SSH key page" do
      subject

      expect(response.body).to include("Create SSH Key")
    end

    context "when the ssh key already exists" do
      before do
        allow(ssh_key_mock).to receive(:public_key?).and_return(true)
      end

      it "redirects to the SSH key page" do
        subject

        expect(response).to redirect_to(ssh_key_path)
      end
    end
  end

  describe "POST /ssh_key" do
    subject { post ssh_key_path }

    it "redirects to the SSH key page" do
      subject

      expect(response).to redirect_to(ssh_key_path)
    end
  end

  describe "DELETE /ssh_key" do
    subject { delete ssh_key_path }

    it "redirects to the new SSH key page" do
      subject

      expect(response).to redirect_to(new_ssh_key_path)
    end
  end
end
