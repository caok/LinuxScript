#!/usr/bin/env ruby
#
# ARGV[0] - msg
# ARGV[1] - mailto
# ARGV[2] - filename

require 'open-uri'
require 'rubygems'
require 'action_mailer'

ActionMailer::Base.smtp_settings = {
  :address              => 'smtp.163.com',
  :port                 => 25,
  :domain               => '163.com',
  :user_name            => 'starcloudsip@163.com',
  :password             => 'xingyun8118',
  :authentication       => 'login',
  :enable_starttls_auto => true
}

class Notifer < ActionMailer::Base
  default :from => 'starcloudsip@163.com'

  def mailip(ip, msg, mailto, file)
    attachments["#{file}"] = File.read("#{file}")
    mail :to => mailto, :subject => "#{msg} ip is #{ip}" do |format|
      format.text { render :text => ip}
    end.deliver
  end
end

open("http://checkip.dyn.com") do |f|
  ip = f.read.slice /[0-9]+(\.[0-9]+){3}/
  filename = "mysql-" + Time.now.strftime("%Y-%m-%d").to_s + ".sql.gz"
  Notifer.mailip ip, ARGV[0], ARGV[1] || 'starclouds.net@gmail.com', ARGV[2] || filename
end
