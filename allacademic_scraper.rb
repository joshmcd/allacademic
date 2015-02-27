#!/usr/bin/env ruby
#still to do: 
	#move text logic to its own loop
	#fix broken "background image" link
	#iterate through pages
	#dump to pdf
	

require 'mechanize'
require 'pdfkit'
require 'open-uri'

agent = Mechanize.new
puts "what's the allacademic link? Right-click/paste."

url = gets
page = agent.get(url)
#default 'http://citation.allacademic.com/meta/p_mla_apa_research_citation/0/7/1/2/0/pages71201/p71201-1.php'

parsed = page.parser
text = File.open('/home/josh/test.html', 'w+')
text << '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' #have to add this so it doesn't screw up the encoding
text << parsed.css('style')
text << parsed.css("html", "body", "center", "table", "tbody", "tr", "td", "table", "tbody", "tr", "td", "table.messages_box", "tbody", "tr.messages_box", "td.messages_box", "table.messages_box_off", "tbody", "tr.messages_box_off", "td.messages_box_off", "table tbody tr td div")[43]
backgroundimage = page.images[5].url.to_s.scan(/([^\/]+)$/)
	a = backgroundimage[0].to_s.gsub('[', '').gsub('"', '').gsub(']', '')
	open('/home/josh/' + a, 'wb') do |file|
		file << open(page.images[5].url).read
	end

numberofpages = page.title.scan(/\d+/)[1].to_i 
count = 0
until count == numberofpages
	count += 1
	page = agent.page.link_with(:text => "next").click
	parsed = page.parser
	text << parsed.css('style')
	text << parsed.css("html", "body", "center", "table", "tbody", "tr", "td", "table", "tbody", "tr", "td", "table.messages_box", "tbody", "tr.messages_box", "td.messages_box", "table.messages_box_off", "tbody", "tr.messages_box_off", "td.messages_box_off", "table tbody tr td div")[43]
	backgroundimage = page.images[5].url.to_s.scan(/([^\/]+)$/)
	a = backgroundimage[0].to_s.gsub('[', '').gsub('"', '').gsub(']', '')
	open('/home/josh/' + a, 'wb') do |file|
		file << open(page.images[5].url).read
	end
	break if page.link_with(:text => "next") == nil
end

kit = PDFKit.new(text)
file = kit.to_file('/home/josh/test.pdf')



