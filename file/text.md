文本处理
--------

统计行数
```sh
wc -l file.txt
```
删除以#开头的行(注释行)
```sh
sed -e '/^#/d' file.txt
```
删除空白行
```sh
sed -e '/^$/d' file.txt
```

清空某个文件的内容
```sh
cat /dev/null > file.txt
```
创建一个新的文件(按CTRL+C结束录入)
```sh
cat > file.txt
or
> file.txt
```
查看文件内容，并在每行前面加上行号
```sh
cat -n file.txt
```
查看文件内容，在不是空行的前面加上行号
```sh
cat -b file.txt
```
合并两个文件的内容
```sh
cat file1.txt file2.txt > file_new.txt
```
合并两个文件的内容，并追回到一个文件
```sh
cat file1.txt file2.txt >> file_total.txt
# file_new若存在>或将其覆盖重写;而>>是在原有的基础上追加，对原来的内容不进行修改
```

a b为两个文本文件
```sh
cat a b | sort | uniq > c         # c是a和b的合集(行的合集，都是以行为单位)
cat a b | sort | uniq -d > c      # c是a和b的交集
cat a b b | sort | uniq -u > c    # c是a和b的不同部分
```

汇总一个文本内容中第三列数字之和
```sh
awk '{ x += $3 } END { print x }' myfile
```

假设你有一个文本文件，比如一个web服务器日志，在某些行上有一些值，比如URL中的acct_id参数。如果你想统计每个acct_id的所有请求记录：
```sh
cat access.log | egrep -o ‘acct_id=[0-9]+’ | cut -d= -f2 | sort | uniq -c | sort -rn
```
