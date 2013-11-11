#coding: utf-8
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
  path = [name, name + ".html"].join("/")
  file = File.new(path, "w+")
  file.puts(content.to_html)
  file.close
  #图片处理
  #校徽
  system "wget -P #{name} #{doc.css('div.school-profile-header-logo img').first.attributes["src"].value}"
  if doc.css('div.statistical-graph').size > 0
    #录入率
    system "wget -P #{name} #{doc.css('div.acceptance-rate div.statistical-graph-pic img').first.attributes["src"].value}"
    #本科生比例
    system "wget -P #{name} #{doc.css('div.student-ratio div.statistical-graph-pic img').first.attributes["src"].value}"
    #SAT
    system "wget -P #{name} #{doc.css('div.sat-scores-range div.statistical-graph-pic img').first.attributes["src"].value}"
  end
  #doc.css('div.school-photo-box ul li.school-photo-item').each do |image|
    #exec "wget -p #{name} #{image_link}"
  #end

  #录取要求页面的处理
  info_link = link + '/info'
  info_doc = Nokogiri::HTML(open(info_link))
  info_content = info_doc.css('div.column#content div.section div#content-area div.node-type-undergradschool')
  info_path = [name, name + "_info.html"].join("/")
  info_file = File.new(info_path, "w+")
  info_file.puts(info_content.to_html)
  info_file.close

  puts "finished ---" + name
end
