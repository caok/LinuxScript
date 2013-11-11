require 'mechanize'
require 'pry'

agent = Mechanize.new
page = agent.get('http://finance.sina.com.cn/oldnews/2012-03-09.html')
page.encoding = 'gb2312'

page.links.each do |link|
  puts link.text
end
