require "base64"
require 'erb'

fonts = %w(KaTeX_AMS KaTeX_Caligraphic KaTeX_Fraktur KaTeX_Main KaTeX_Math KaTeX_SansSerif KaTeX_Script KaTeX_Size1 KaTeX_Size2 KaTeX_Size3 KaTeX_Size4 KaTeX_Typewriter)

class Render
  attr_reader :html, :family, :base64, :weight, :style

  def initialize(family, file, weight, style)
    @family = family
    @base64 = Base64.encode64(File.new(file).read)
    @weight = weight
    @style = style

    @template = <<EOF
@font-face {
  font-family: '<%= family %>';
  src: url('data:application/x-font-woff;charset=utf-8;base64,<%= base64 %>'), format('woff');
  font-weight: <%= @weight %>;
  font-style: <%= @style %>;
}
EOF
  end

  def render
    ERB.new(@template, 0, "", "@html").result(binding)
  end
end

fonts.each do |font|
	regular_file = "#{font}-Regular.woff"
	if File.exists?(regular_file)
		puts Render.new(font, regular_file, 'normal', 'normal').render
	end
	bold_file = "#{font}-Bold.woff"
	if File.exists?(bold_file)
		puts Render.new(font, bold_file, 'bold', 'normal').render
	end
	italic_file = "#{font}-Italic.woff"
	if File.exists?(italic_file)
		puts Render.new(font, italic_file, 'bold', 'italic').render
	end
end⏎   