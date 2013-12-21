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

  puts "-----------login success-----------"
  sleep 2
  return true
rescue => e
  puts "-----------login error-------------"
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

def maoquan
  visit('http://ka.tmall.com')
  find('div.right_button').click
  puts('签到领猫券')
  sleep 2
rescue
  sleep 5
  retry
end

def etao_sign_in(jf_count = 0)
  %w{'http://jf.etao.com', 'http://www.etao.com'}.each do |url|
    visit('http://www.etao.com')
    find('div.ci_receive').click
    if find('p.message-info', :text => '您今天已经领过了哦！')
      puts "已经签到."
    elsif find('p.message-info', :text => '恭喜你签到获得1个集分宝！')
      puts "一淘签到."
      return
    end
    sleep 2
  end
rescue
  if jf_count > 4
    puts "领取集分宝失败!"
    return
  else
    jf_count += 1
    puts jf_count
    sleep 5
    retry
  end
end

def taojinbi(jinbi_count = 0)
  visit('http://vip.taobao.com')
  find('a.coin-btn').click
  puts "领淘金币."
  sleep 2
rescue
  if (jinbi_count > 4)
    puts "领取淘金币失败!"
    return
  else
    jinbi_count += 1
    puts jinbi_count
    sleep 5
    retry
  end
end

if login
  puts "---------猫  券-------"
  maoquan
  puts "---------集分宝-------"
  etao_sign_in()
  puts "---------淘金币-------"
  taojinbi()
end
