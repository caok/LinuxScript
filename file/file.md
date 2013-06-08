文件处理
---------

让当前目录中文件属主具有读、写权限，并且文件所属组的用户和其他用户具有读权限的文件；
```sh
find . -perm 644 -exec ls -l {} \;
```
为了查找系统中所有文件长度为0的普通文件，并列出它们的完整路径；
```sh
find / size 0 -type f -exec ls -l {} \;
```
查找/var/logs目录中更改时间在7日以前的普通文件，并在删除之前询问它们；
```sh
find /var/logs -mtime +7 -type f -ok rm -i {} \;
```
为/找系统中所有属于root组的文件；
```sh
find / -group root -exec ls -l {} \;
```
find命令将删除当目录中访问时间在7日以来、含有数字后缀的admin.log文件
```sh
find . -name "admin.log[0-9][0-9][0-9]" -atime -7 -ok rm { } \;
```
为了查找当前文件系统中的所有目录并排序
```sh
find . -type d | sort
```
查看一个目录树里的文件的体积和修改日期(挨个目录做ls -l)
```sh
find . -type f -ls
```


