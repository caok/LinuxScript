#coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'pry'

count = 0
0.upto(60) do |i|
  url = "http://www.zinch.cn/ss/us?page=#{i}&sort=fans&order=desc"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('div.zinch-school-search-results-list div.school-list-block').each do |university|
    name = university.css('div.school-name-total h2 a').first.content
    link = university.css('div.school-name-total h2 a').first.attributes["href"].value
    link = "http://www.zinch.cn" + link.rstrip.lstrip.gsub(/ /,"-")
    if name.nil? || name.empty?
      puts "该学校没有中文名，故忽略"
    elsif(File.exist?(name))
      puts "该学校文件夹已经存在"
    else
      Dir.mkdir(name)
      path = [name, name + ".html"].join("/")
      file = File.new(path, "w+")
      doc = Nokogiri::HTML(open(link))
      content = doc.css('div.column#content div.section')
      file.puts(content.to_html)
      file.close
      #图片处理
      #校徽
      system "wget -P #{name} #{doc.css('div.school-profile-header-logo img').first.attributes["src"].value}"
      if doc.css('div.statistical-graph').size > 0
        #录入率
        acceptance_rate = doc.css('div.acceptance-rate div.statistical-graph-pic img').first
        system "wget -P #{name} #{acceptance_rate.attributes["src"].value}" if acceptance_rate && acceptance_rate.attributes
        #本科生比例
        ratio = doc.css('div.student-ratio div.statistical-graph-pic img').first
        system "wget -P #{name} #{ratio.attributes["src"].value}" if ratio && ratio.attributes
        #SAT
        sat_scores_range = doc.css('div.sat-scores-range div.statistical-graph-pic img').first
        system "wget -P #{name} #{sat_scores_range.attributes["src"].value}" if sat_scores_range && sat_scores_range.attributes
      end

      #录取要求页面的处理
      info_link = link.rstrip.lstrip.gsub(/ /,"-") + '/info'
      info_doc = Nokogiri::HTML(open(info_link))
      info_content = info_doc.css('div.column#content div.section div#content-area div.node-type-undergradschool')
      info_path = [name, name + "_info.html"].join("/")
      info_file = File.new(info_path, "w+")
      info_file.puts(info_content.to_html)
      info_file.close
      school_photo_item = info_doc.css('div.school-photo-box ul li.school-photo-item a')
      if school_photo_item.size > 0 && school_photo_item.first.children.size > 0
        system "wget -P #{name} #{school_photo_item.first.children[0].attributes.first.last.value}"
      end

      count += 1
      puts "finished ----#{count}----" + name
    end
  end
end
