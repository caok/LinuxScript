Backup
===========

#### 备份mysql中的数据库
```sh
bash backup_mysql.sh
# 具体参数需在文件中修改
```

#### 通过SSH将MySQL数据库复制到新服务器

通过压缩的SSH隧道Dump一个MySQL数据库，将其作为输入传递给mysql命令，我认为这是迁移数据库到新服务器最快最好的方法。
```sh
mysqldump –add-drop-table –extended-insert –force –log-error=error.log -uUSER -pPASS OLD_DB_NAME | ssh -C user@newhost "mysql -uUSER -pPASS NEW_DB_NAME"
```

#### 从服务器上备份重要文件(只替换修改过的文件)
```sh
rsync -vare ssh jono@192.168.0.2:/home/jono/importantfiles/* /home/jono/backup/
```

#### Backup selected files only
Want to use tar to backup only certain files in a directory? Then you'll want to use the -T flag as follows. First, create a file with the file you want to backup:
```
cat >> /etc/backup.conf
# /etc/passwd
# /etc/shadow
# /etc/yp.conf
# /etc/sysctl.conf
EOF
```
Then run tar with the -T flag pointing to the file just created:
```sh
tar -cjf bck-etc-`date +%Y-%m-%d`.tar.bz2 -T /etc/backup.conf
```
Now you have your backup.
