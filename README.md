LinuxScript
===========

Some script I use with my computer.

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
合并两具文件的内容，并追回到一个文件
```sh
cat file1.txt file2.txt >> file_total.txt
# file_new若存在>或将其覆盖重写;而>>是在原有的基础上追加，对原来的内容不进行修改
```







NO1. 查找当前用户主目录下的所有文件
[root@rehat root]# find ~
NO2. 让当前目录中文件属主具有读、写权限，并且文件所属组的用户和其他用户具有读权限的文件；
[root@rehat root]# find . -perm 644 -exec ls -l {} \;
NO3. 为了查找系统中所有文件长度为0的普通文件，并列出它们的完整路径；
[root@rehat root]# find / size 0 -type f -exec ls -l {} \;
NO4. 查找/var/logs目录中更改时间在7日以前的普通文件，并在删除之前询问它们；
[root@rehat root]# find /var/logs -mtime +7 -type f -ok rm -i {} \;
NO5. 为/找系统中所有属于root组的文件；
[root@rehat root]# find / -group root -exec ls -l {} \;
NO6. find命令将删除当目录中访问时间在7日以来、含有数字后缀的admin.log文件
[root@rehat root]# find . -name "admin.log[0-9][0-9][0-9]" -atime -7 -ok rm { } \;
NO7. 为了查找当前文件系统中的所有目录并排序
[root@rehat root]# find . -type d | sort

