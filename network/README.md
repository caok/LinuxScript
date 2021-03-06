Network
===========

通过shell 脚本查看服务器的实时流量
```sh
bash network.sh
```

下载网站文档
```sh
wget -m -p -E -k -K -np http://twitter.github.io/bootstrap/
```

查询ip address
```sh
curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+'
```

#### Netstat
查看使用80端口的进程
```sh
netstat -lnp | grep :80
```
检查本机各端口的网络连接情况
```sh
netstat -ant
```
查看当前网络连接状况及各自的程序
```sh
netstat -atnp
```
查看路由信息
```sh
netstat -rn
or
route
```

#### NMAP
扫描局域网有多少主机处于运行状态
```sh
nmap 192.168.0.0/24
or
nmap 192.168.0.1-254
```
扫描某个ip的操作系统
```sh
nmap -O 192.168.0.100
```
扫描某个ip的固定端口
```sh
nmap -p 25 192.168.0.100
```
查看某个ip上某个端口用什么程序运行的
```sh
nmap -sV 192.168.0.100
```

查看域名备案
```sh
whois caok1231.com
```
Use the correct whois server
```sh
whois -h whois.geektools.com caok1231.com
```
查看域名的dns信息
```sh
dig caok1231.com
```

Local HTTP server
```sh
python -m SimpleHTTPServer
```

杀死Nginx进程(杀死某一进程)
```sh
for i in `ps aux | grep nginx | grep -v grep | awk {'print $2'}` ; do kill $i; done
```

#### SSH
[25个必须记住的SSH命令](http://web.itivy.com/article-361-1.html)
