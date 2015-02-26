#!/usr/bin/env ruby
#still to do: 
	#figure out why the encoding is mangling long dashes
	#move text logic to its own loop
	#fix broken "background image" link
	#iterate through pages
	#dump to pdf
	

require 'mechanize'
require 'wkhtmltopdf'
require 'pdfkit'

agent = Mechanize.new
puts "what's the allacademic link? Right-click/paste."
url = gets
page = agent.get(url)
parsed = page.parser
a = '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' #have to add this so it doesn't screw up the encoding
text = a + parsed.css("html", "body", "center", "table", "tbody", "tr", "td", "table", "tbody", "tr", "td", "table.messages_box", "tbody", "tr.messages_box", "td.messages_box", "table.messages_box_off", "tbody", "tr.messages_box_off", "td.messages_box_off", "table tbody tr td div")[43]

css = File.open('css.css', 'w') { |i| i << parsed.css('style') }
css = File.open('css.css', 'r')
File.open('C:\Users\jmcdon39\Desktop\test.html', 'w') do |i|
  css.each_line { |p| i << p }
  i << text
end

