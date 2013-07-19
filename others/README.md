显示10条最常用的命令
```sh
sed -e "s/| /\n/g" ~/.bash_history | cut -d ' ' -f 1 | sort | uniq -c | sort -nr | head
```

显示不是你创建的进程
```sh
ps aux | grep -v `whoami`
# list the top ten time-wasters
ps aux  --sort=-%cpu | grep -m 11 -v `whoami`
```


