require 'nokogiri'
require 'open-uri'
require 'pry'

linksdoc = Nokogiri::HTML(open('http://www.zinch.cn/top/university/world/times-higher-education-world-university-rankings'))
linksdoc.css('div#content-area div.top-university-results-list div.school-list-block').each do |university|
  name = university.css('h2.school-name-total a').first.content
  link = university.css('h2.school-name-total a').first.attributes["href"].value
  doc = Nokogiri::HTML(open(link))
  content = doc.css('div.column#content div.section')
  Dir.mkdir(name)
  path = [name, name].join("/")
  file = File.new(path, "w+")
  file.puts(content.text)
  file.close
  #图片处理
  #校徽
  system "wget -P #{name} #{doc.css('div.school-profile-header-logo img').first.attributes["src"].value}"
  #doc.css('div.school-photo-box ul li.school-photo-item').each do |image|
    #exec "wget -p #{name} #{image_link}"
  #end
  puts "finished ---" + name
end