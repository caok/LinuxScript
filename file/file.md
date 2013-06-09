文件处理
---------

查看各个目录占用空间大小
```sh
du -h --max-depth=1
```

统计某文件夹下目录以及文件的个数(忽略目录中的文件)
```sh
ls -l | wc -l
```
统计某文件夹下文件的个数
```sh
ls -l | grep "^-" | wc -l
```
统计某文件夹下目录的个数
```sh
ls -l | grep "^d"| wc -l
```
统计文件夹下文件的个数，包括子文件夹里的
```sh
ls -lR | grep "^-" | wc -l
```

查找当前文件系统中的所有目录并排序
```sh
find . -type d | sort
```
查看一个目录树里的文件的体积和修改日期(挨个目录做ls -l)
```sh
find . -type f -ls
```

查找指定路径下，文件名包含"report"字段的文件
```sh
find ./app/views/ | grep "report"
```
查找制定路径下，在某类文件中包含"error"字段的文件
```
find / -type f -name "*.log" | xargs grep "error"
```


