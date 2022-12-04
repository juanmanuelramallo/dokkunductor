require "rails_helper"

RSpec.describe AnsiToHtml do
  describe "#to_html" do
    subject { described_class.new(text).to_html }

    let(:text) do
      <<~TXT
        foo\e[36mbar\e[0m
        baz
      TXT
    end

    it "converts ansi codes to html" do
      expect(subject).to eq(<<~TXT.squish)
        foo<span class="ansi-36">bar</span><br>baz<br>
      TXT
    end
  end
end
