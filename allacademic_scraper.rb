#!/usr/bin/env ruby
#still to do: 
	#move text logic to its own loop
	#fix broken "background image" link
	#iterate through pages
	#dump to pdf
	

require 'mechanize'
require 'pdfkit'

agent = Mechanize.new
puts "what's the allacademic link? Right-click/paste."
url = gets
page = agent.get(url)
#default 'http://citation.allacademic.com/meta/p_mla_apa_research_citation/0/7/1/2/0/pages71201/p71201-1.php'

parsed = page.parser
text = parsed.css("html", "body", "center", "table", "tbody", "tr", "td", "table", "tbody", "tr", "td", "table.messages_box", "tbody", "tr.messages_box", "td.messages_box", "table.messages_box_off", "tbody", "tr.messages_box_off", "td.messages_box_off", "table tbody tr td div")[43]
css = File.open('css.css', 'w') { |i| i << parsed.css('style') }
css = File.open('css.css', 'r')

File.open('/home/josh/test.html', 'w') do |i|
  i << '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' #have to add this so it doesn't screw up the encoding
  css.each_line { |p| i << p }
end

#this works when done individually, so there must be a better way
while page.link_with(:text => "next") == true
	page = page.link_with(:text => "next").click
	parsed = page.parser
	text << parsed.css("html", "body", "center", "table", "tbody", "tr", "td", "table", "tbody", "tr", "td", "table.messages_box", "tbody", "tr.messages_box", "td.messages_box", "table.messages_box_off", "tbody", "tr.messages_box_off", "td.messages_box_off", "table tbody tr td div")[43]
end

File.open('/home/josh/test.html', 'w') do |i|
	i << text
end


