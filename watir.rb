require 'watir'

browser = Watir::Browser.new

browser.goto 'watir.com'
browser.link(text: 'documentation').click

puts browser.title
browser.close