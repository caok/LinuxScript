文件处理
---------

####du
查看各个目录占用空间大小
```sh
du -h --max-depth=1
```
列出当前文件夹目录大小，以G，M，K显示
```sh
du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf"%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"):$1>=2**10? ($1/2**10, "K"): ($1, "")}e'
```

####ls
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

####find
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

 将当前目录文件名全部转换成小写
 ```sh
 for i in *; do mv "$i" "$(echo $i|tr A-Z a-z)"; done
 ```


