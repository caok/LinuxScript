require 'net/http'  
require 'thread'  
require "open-uri"  
require "fileutils"  
  
module Log  
  def Log.i(msg)  
    print "[INFO]#{msg}\n"  
  end  
  def Log.e(msg)  
    print "[ERROR]#{msg}\n"  
  end  
end  
  
class UrlObj  
  attr_accessor :url,:depth,:save_name  
  def initialize(url,depth,save_name)  
    @url=url  
    @save_name=save_name  
    @depth=depth  
  end  
  
  def info  
    return @info if @info  
    begin  
      @info=URI.parse(@url)  
      return @info  
    rescue Exception=>e  
      Log.e e  
      return nil  
    end  
  end  
  #Get url's domain  
  def domain  
    if @domain  
      return @domain  
    elsif !info  
      Log.e("#{@url}'s host is nil")  
      return nil  
    elsif !info.host  
      Log.e("#{@url}'s host is nil")  
      return nil  
    else  
      return info.host[/\w+\.\w+$/]  
    end  
  end  
end  
    
class WebSnatcher  
  THREAD_SLEEP_TIME=0.5  
  HTTP_RETRY_TIMES=3  
  
  
  def initialize(opt={},&block)  
    @url_check=block;  
    @url_to_download=[]  
    @url_to_download_count=0  
    @html_name_counter=0  
    @file_name_counter=0  
    @bad_urls=[]  
    @url_history={}  
    @file_history={}  
    @thread_count=opt[:thread_count]||=10  
    @mutex=Mutex.new#Initialise the mutex for threads  
    @dig_depth_limit=opt[:depth]||=2  
    @work_path=opt[:work_path]||File.dirname(__FILE__)+"/output/"  
    @other_file_path=@work_path+"others/"  
    FileUtils.mkdir_p @other_file_path unless File.directory?(@other_file_path)  
    Log.i "Downloaded files will save to #{@work_path}"  
    @max_file_size=opt[:max_file_size]||nil  
    @min_file_size=opt[:min_file_size]||nil  
    @include_url_matcher=opt[:url_regexp]||[]  
    @exclude_url_matcher=[]  
    @need_type={}      
    if opt[:file_limit]  
      opt[:file_limit].each { |filetype|  
        @need_type[filetype]=true  
      }  
    else  
      @need_all=true  
    end  
  end  
  
  def append_include_url_matcher(regexp)  
    @include_url_matcher<<regexp if regexp.instance_of?(Regexp)  
    return self  
  end  
  def append_exclude_url_matcher(regexp)  
    @exclude_url_matcher<<regexp if regexp.instance_of?(Regexp)  
    return self  
  end  
  def get_url_to_download  
    @mutex.synchronize do  
      if @url_to_download_count>0  
        url=@url_to_download.shift  
        @url_to_download_count-=1  
        return url  
      else  
        return nil  
      end  
    end  
  end  
    
  def add_url_to_download(url)  
    @mutex.synchronize do  
      @url_to_download.push(url)  
      @url_to_download_count+=1  
    end  
  end  
  
  def add_url_to_history(url,save_name)  
    @url_history[url]=save_name  
  end  
  
  def amend_url(url,ref)  
    return nil unless url  
    return url if url=~/^http:\/\/.+/  
    url=url.sub(/#\w+$/, "")  
    return amend_url($1,ref) if url=~/^javascript:window\.open\(['"]{0,1}(.+)['"]{0,1}\).*/i#<a href="javascript:window.open("xxxx")">  
    return nil if url=~/javascript:.+/i  
    return "http://"+url if url=~/^www\..+/#www.xxxxx.com/dddd  
    return "http://"+ref.info.host+url if url=~/^\/.+/#root path url  
    return ref.url.sub(/\/[^\/]*$/,"/#{url}") if url=~/^[^\/^\.].+/  #simple filename like 123.html  
    if url=~/^\.\/(.+)/ #./pmmsdfe.jpg  
      return ref.url.sub(/\/[^\/]+$/,"/#{$1}")  
    end  
    if url=~/^\.\.\/(.+)/ #../somthing.jpg  
      return ref.url.sub(/\/\w+\/[^\/]*$/, "/#{$1}")  
    end  
    nil  
  end  
  
  
  def get_html_save_name  
    @hnm||=Mutex.new  
    @hnm.synchronize {  
      @html_name_counter+=1  
      return "#{@html_name_counter}.html"  
    }  
  end  
  
  def get_file_save_counter  
    @fnl||=Mutex.new  
    @fnl.synchronize{  
      return @file_name_counter+=1  
    }  
  end  
  
  
  def match_condition?(url_obj)  
    @include_url_matcher.each{|rep|  
      return true if url_obj.url=~rep  
    }  
    @exclude_url_matcher.each{|rep|  
      return false if url_obj.url=~rep  
    }  
    return false if @bad_urls.include?(url_obj.url)  
    if !(@base_url_obj.domain)||@base_url_obj.domain!=url_obj.domain  
      return false  
    else  
      return true  
    end  
  end  
  
  def write_text_to_file(path,content)  
    File.open(path, 'w'){|f|  
      f.puts(content)  
    }  
    Log.i("HTML File have saved to #{path}")  
  end  
  
  def download_to_file(_url,save_path)  
    return unless _url  
    begin  
      open(_url) { |bin|  
        size=bin.size  
        return if @max_file_size&&size>@max_file_size||@min_file_size&&size<@min_file_size  
        Log.i("Downloading: #{_url}|sze:#{size}")  
        File.open(save_path,'wb') { |f|  
          while buf = bin.read(1024)  
            f.write buf  
            STDOUT.flush  
          end  
        }  
      }  
    rescue Exception=>e  
      Log.e("#{_url} Download Failed!"+e)  
      return  
    end  
    Log.i "File has save to #{save_path}!!"  
  end  
  
  def deal_with_url(url_obj)  
    Log.i "Deal with url:#{url_obj.url};depth=#{url_obj.depth}"  
    return unless url_obj.instance_of?(UrlObj)  
    retry_times=HTTP_RETRY_TIMES  
    content=nil  
    0.upto(HTTP_RETRY_TIMES) { |i|  
      begin  
        return unless url_obj.info  
        Net::HTTP.start(url_obj.info.host,url_obj.info.port)  
        content=Net::HTTP.get(url_obj.info)  
        retry_times-=1  
        break  
      rescue  
        next if i<HTTP_RETRY_TIMES#stop trying until has retry for 5 times  
        Log.i "Url:#{url_obj.url} Open Failed!"  
        return  
      end  
    }  
    Log.i "Url:#{url_obj.url} page has been read in!"  
    return unless content  
    if url_obj.depth<@dig_depth_limit||@dig_depth_limit==-1  
      urls = content.scan(/<a[^<^{^(]+href="([^>^\s]*)"[^>]*>/im)  
      urls.concat content.scan(/<i{0,1}frame[^<^{^(]+src="([^>^\s]*)"[^>]*>/im)  
      urls.each { |item|  
        anchor=item[0][/#\w+/]#deal with the anchor  
        anchor="" unless anchor  
        full_url=amend_url(item[0],url_obj)  
        next unless full_url  
        if @url_history.has_key?(full_url)#if already have downloades this url replace the links  
          content.gsub!(item[0],@url_history.fetch(full_url)+anchor)  
        else#add to url tasks  
          #if match download condition,add to download task  
          save_name=get_html_save_name  
          new_url_obj=UrlObj.new(full_url, url_obj.depth+1,save_name)  
          if match_condition?(new_url_obj)  
            Log.i "Add url:#{new_url_obj.url}"  
            add_url_to_download new_url_obj  
            content.gsub!(item[0], save_name+anchor)  
            add_url_to_history(full_url,save_name)  
          end  
        end  
      }  
    end  
    #Downloadd Other files  
    files=[]  
    #search for image  
    files.concat content.scan(/<img[^<^{^(]+src=['"]{0,1}([^>^\s^"]*)['"]{0,1}[^>]*>/im) if @need_type[:image]||@need_all  
    #search for css  
    files.concat content.scan(/<link[^<^{^(]+href=['"]{0,1}([^>^\s^"]*)['"]{0,1}[^>]*>/im) if @need_type[:css]||@need_all  
    #search for javascript  
    files.concat content.scan(/<script[^<^{^(]+src=['"]{0,1}([^>^\s^"]*)['"]{0,1}[^>]*>/im) if @need_type[:js]||@need_all  
      
    files.each {|f|  
      full_url=amend_url(f[0],url_obj)  
        
      next unless full_url  
      base_name=File.basename(f[0])#get filename  
      base_name.sub!(/\?.*/,"")  
      full_url.sub!(/\?.*/,"")  
      #      unless base_name=~/[\.css|\.js]$/  
      base_name="#{get_file_save_counter}"+base_name  
      #      end  
      if @file_history.has_key?(full_url)  
        filename=@file_history[full_url]  
        content.gsub!(f[0],"others/#{filename}")  
      else  
        download_to_file full_url,@other_file_path+base_name  
        content.gsub!(f[0],"others/#{base_name}")  
        @file_history[full_url]=base_name  
        #        add_url_to_history(full_url,base_name)  
      end  
      files.delete f  
    }  
    #save content  
    if @need_type[:html]||@need_all  
      write_text_to_file(@work_path+url_obj.save_name, content)  
      Log.i "Finish dealing with url:#{url_obj.url};depth=#{url_obj.depth}"  
    end  
  end  
  
  def run(*base_url)  
    @base_url=base_url[0] if @base_url==nil  
    Log.i "<---------START--------->"  
    @base_url_obj=UrlObj.new(@base_url,0,"index.html")  
    m=Mutex.new  
    threads=[]  
    working_thread_count=0  
    @thread_count.times{|i|  
      threads<<Thread.start() {  
        Log.i "Create id:#{i} thread"  
        loop do  
          url_to_download=get_url_to_download  
          if url_to_download  
            m.synchronize {  
              working_thread_count+=1  
            }  
            begin  
              deal_with_url url_to_download  
            rescue Exception=>e  
              Log.e "Error: " +e  
              @bad_urls.push(url_to_download.url)  
            end  
            m.synchronize {  
              working_thread_count-=1  
            }  
          else  
            sleep THREAD_SLEEP_TIME  
          end  
        end  
      }  
    }  
    #Create a monitor thread  
    wait_for_ending=false  
    monitor=Thread.start() {  
      loop do  
        sleep 2.0  
        Log.i "Working threads:#{working_thread_count}|Ramain Url Count:#{@url_to_download_count}"  
        next unless wait_for_ending  
        if @url_to_download_count==0 and working_thread_count==0  
          Log.i "Finish downloading,Stoping threads..."  
          threads.each { |item|  
            item.terminate  
          }  
          Log.i("All Task Has Finished")  
          break  
        end  
      end  
      Log.i "<---------END--------->"  
    }  
    deal_with_url @base_url_obj  
    wait_for_ending=true  
    Log.i "main thread wait until task finished!"  
    #main thread wait until task finished!  
    monitor.join  
  end  
end  
  
  
#Linux c函数参考  
#snatcher=WebSnatcher.new(:work_path=>"E:/temp/",:depth=>2)  
#snatcher.append_exclude_url_matcher(/http:\/\/man\.chinaunix\.net\/{0,1}$/i)  
#snatcher.run("http://man.chinaunix.net/develop/c&c++/linux_c/default.htm")  
#http://www.kuqin.com/rubycndocument/man/index.html  
  
snatcher=WebSnatcher.new(:work_path=>".",:depth=>2)  
snatcher.run("http://www.zinch.cn/top/university/world/times-higher-education-world-university-rankings")  
