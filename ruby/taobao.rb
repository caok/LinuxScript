# encoding: utf-8
#
# 淘宝签到领集分宝脚本
# 当前目录建立 tmall 文件放入帐号:密码，分号隔开
#
# 直接通过淘宝登录需要手机动态密码验证等，通过天猫最方便些
#
# mailto caok1231@gmail.com
# blog http://caok1231.com

require 'rubygems'
require 'capybara'
require 'capybara/dsl'
include Capybara::DSL

Capybara.default_driver = :selenium
Capybara.app_host = 'http://www.taobao.com'

def login
  username, password = IO.read('tmall').split(':')

  visit('http://login.tmall.com')

  setup_frame('loginframe')
  within_frame('loginframe') do
    fill_in 'TPL_username', :with => username
    fill_in 'TPL_password', :with => password
    click_button '登录'
  end
rescue => e
  puts e
end

def setup_frame(name)
  jquerify
  page.execute_script %Q{
    jQuery('iframe').attr('name', '#{name}');
  }
end

def jquerify
  page.execute_script %Q{
    var jq = document.createElement('script');
    jq.src = "http://code.jquery.com/jquery-latest.min.js";
    document.getElementsByTagName('head')[0].appendChild(jq);
  }
  # wait to load jquery
  sleep 2
end

def etao_sign_in
  visit('http://www.etao.com')
  find('div.ci_receive').click
end

def taojinbi
  visit('http://vip.taobao.com')
  find('a.coin-btn').click
end

login
etao_sign_in
taojinbi
