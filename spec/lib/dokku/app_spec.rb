require "rails_helper"

RSpec.describe Dokku::App do
  let(:app) { described_class.new(name: "dokkunductor") }

  describe ".all" do
    subject { described_class.all }

    let(:command_mock) { instance_double(Dokku::Command) }
    let(:result) do
      <<~STR
        =====> My Apps
        dokkunductor
        myapp
      STR
    end

    before do
      allow(Dokku::Command).to receive(:new).and_return(command_mock)
      allow(command_mock).to receive(:run).and_return(result)
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
    let(:command_mock) { instance_double(Dokku::Command) }

    before do
      allow(Dokku::Command).to receive(:new).and_return(command_mock)
    end

    it "creates a new app" do
      expect(command_mock).to receive(:run).with("apps:create dokkunductor").and_return("-----> Creating dokkunductor...")
      expect(subject).to have_attributes(name: "dokkunductor")
    end

    context "when the app is already created" do
      it "returns nil" do
        expect(command_mock).to receive(:run).with("apps:create dokkunductor").and_return(" !     Name is already taken")
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

    let(:command_mock) { instance_double(Dokku::Command) }

    before do
      allow(Dokku::Command).to receive(:new).and_return(command_mock)
      allow(command_mock).to receive(:run).with("apps:create dokkunductor").and_return("-----> Creating dokkunductor...")
    end

    it { is_expected.to eq(true) }

    context "when the app is already created" do
      before do
        allow(command_mock).to receive(:run).with("apps:create dokkunductor").and_return(" !     Name is already taken")
      end

      it { is_expected.to eq(false) }

      it "adds an error" do
        subject
        expect(app.errors).to have_key(:base)
      end
    end
  end
end
