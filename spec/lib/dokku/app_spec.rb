require "rails_helper"

RSpec.describe Dokku::App do
  let(:app) { described_class.new(name: "dokkunductor") }
  let(:command_mock) { instance_double(Ssh) }

  before do
    report = <<~STR
      =====> applogger app information
       App created at:                1663545578
       App deploy source:
       App deploy source metadata:
       App dir:                       /home/dokku/dokkunductor
       App locked:                    false
    STR
    command = instance_double(Ssh)
    allow(Ssh).to receive(:new).and_return(command)
    allow(command).to receive(:exec).with("apps:report #{app.name}").and_return(report)
  end

  describe ".all" do
    subject { described_class.all }

    let(:result) do
      <<~STR
        =====> My Apps
        dokkunductor
        myapp
      STR
    end

    before do
      allow(Ssh).to receive(:new).and_return(command_mock)
      allow(command_mock).to receive(:exec).and_return(result)
    end

    it "returns all apps" do
      expect(subject).to contain_exactly(
        have_attributes(name: "dokkunductor"),
        have_attributes(name: "myapp")
      )
    end

    context "without apps deployed" do
      let(:result) do
        <<~STR
          =====> My Apps
          !     You haven't deployed any applications yet
        STR
      end

      it { is_expected.to eq([]) }
    end
  end

  describe ".create" do
    subject { described_class.create(name: name) }

    let(:name) { "dokkunductor" }

    before do
      allow(Ssh).to receive(:new).and_return(command_mock)
    end

    it "creates a new app" do
      expect(command_mock).to receive(:exec).with("apps:create dokkunductor").and_return("-----> Creating dokkunductor...")
      expect(subject).to have_attributes(name: "dokkunductor")
    end

    context "when the app is already created" do
      it "returns nil" do
        expect(command_mock).to receive(:exec).with("apps:create dokkunductor").and_return(" !     Name is already taken")
        expect(subject.errors).to have_key(:base)
      end
    end
  end

  describe "#name" do
    subject { app.name }

    it { is_expected.to eq("dokkunductor") }
  end

  describe "#save" do
    subject { app.save }

    before do
      allow(Ssh).to receive(:new).and_return(command_mock)
      allow(command_mock).to receive(:exec).with("apps:create dokkunductor").and_return("-----> Creating dokkunductor...")
    end

    it { is_expected.to eq(true) }

    context "when the app is already created" do
      before do
        allow(command_mock).to receive(:exec).with("apps:create dokkunductor").and_return(" !     Name is already taken")
      end

      it { is_expected.to eq(false) }

      it "adds an error" do
        subject
        expect(app.errors).to have_key(:base)
      end
    end
  end

  describe "#report" do
    subject { app.report }

    it { is_expected.to be_a(String) }
  end

  describe "#git_remote_name" do
    subject { app.git_remote_name }

    it { is_expected.to eq("dokku@dokku.me:dokkunductor") }
  end

  describe "#config" do
    subject { app.config }

    before do
      allow(Ssh).to receive(:new).and_return(command_mock)
      allow(command_mock).to receive(:exec).and_return(<<~STR)
        =====> dokkunductor env vars
        DATABASE_URL: postgres://postgres:postgres@postgres:5432/dokkunductor
        RAILS_ENV: production
      STR
    end

    it "returns a hash" do
      expect(subject).to include(
        "DATABASE_URL" => "postgres://postgres:postgres@postgres:5432/dokkunductor",
        "RAILS_ENV" => "production"
      )
    end

    context "when app does not exist" do
      before do
        allow(command_mock).to receive(:exec).and_return(" !     App dokkunductor does not exist")
      end

      it "returns an empty hash" do
        expect(subject).to eq({})
      end
    end
  end
end
