class AnsiToHtml
  def initialize(text)
    @text = text
  end

  def to_html
    @text.gsub(/\e\[0m/, "</span>")
      .gsub(/\e\[(\d+)m/, '<span class="ansi-\1">')
      .gsub(/\n/, "<br>")
  end
end
