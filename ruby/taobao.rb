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

def login(count = 0)
  username, password = IO.read('tmall').split(':')

  visit('http://login.tmall.com')

  setup_frame('loginframe')
  within_frame('loginframe') do
    fill_in 'TPL_username', :with => username
    fill_in 'TPL_password', :with => password
    click_button '登录'
  end

  puts "登录成功，开始签到..."
  sleep 2
  return true
rescue => e
  if count > 4
    puts "登录失败!"
    return
  else
    count += 1
    puts "第#{count}次登录失败，继续尝试登录........"
    puts e
    sleep 3
    retry
  end
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
  3.times.each do
    find('div.right_button').click
    sleep 2
  end
  puts('签到领猫券.')
rescue
  sleep 5
  retry
end

def etao_sign_in(jf_count = 0)
  ["http://jf.etao.com", "http://www.etao.com"].each do |url|
    visit(url)
    find('div.ci_receive').click
    if page.has_css?('p.message-info', :text => '您今天已经领过了哦！', :visible => true)
      puts "已经签到."
      return
    elsif page.has_css?('p.message-info', :text => '恭喜你签到获得1个集分宝！', :visible => true)
      puts "一淘签到."
      return
    else
      continue
    end
    sleep 2
  end
rescue => e
  if jf_count > 4
    puts "领取集分宝失败!"
    return
  else
    jf_count += 1
    puts e
    puts "第#{jf_count}次领取集分宝失败，继续尝试........"
    sleep 5
    retry
  end
end

def taojinbi(jinbi_count = 0)
  visit('http://vip.taobao.com')
  if find('a.coin-count')
    puts "已经领过淘金币."
  else
    find('a.get-coinbtn').click
    puts "领淘金币."
  end
  sleep 2
rescue
  if (jinbi_count > 4)
    puts "领取淘金币失败!"
    return
  else
    jinbi_count += 1
    puts "第#{jinbi_count}次领取淘金币失败，继续尝试........"
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
