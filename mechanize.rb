require 'rubygems'
require 'mechanize'

# baidu start 
agent = Mechanize.new

page = agent.get('http://www.baidu.com/')
page.links.each do |link|
	puts link.text
	puts "========"
end

# page_click = agent.page.links.find{|l| l.text == "新闻"}.click
page_click = agent.page.link_with(:text=>"新闻").click
puts page_click

# undefined method 'q=' for Mechanize::Form
page_form = page.form("f")
page_form.q = 'ruby mechanize'
page_response = agent.submit(page_form)
# baidu end

# bing start
a = Mechanize.new { |agent|
	agent.user_agent_alias = 'Mac Safari'
}

a.get('http://bing.com/') do |page|
  search_result = page.form_with(:id => 'gbqf') do |search|
    search.q = 'Hello world'
  end.submit

  search_result.links.each do |link|
    puts link.text
  end
end
# bing end
