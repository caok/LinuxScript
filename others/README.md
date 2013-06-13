显示10条最常用的命令
```sh
sed -e "s/| /\n/g" ~/.bash_history | cut -d ' ' -f 1 | sort | uniq -c | sort -nr | head
```
