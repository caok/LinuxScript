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

查看域名备案
```sh
whois baidu.com
```
查看域名的dns信息
```sh
dig baidu.com
```

Local HTTP server
```sh
python -m SimpleHTTPServer 8080
```

杀死Nginx进程(杀死某一进程)
```sh
for i in `ps aux | grep nginx | grep -v grep | awk {'print $2'}` ; do kill $i; done
```
