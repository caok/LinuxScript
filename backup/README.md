Backup
===========

备份mysql中的数据库
```sh
bash backup_mysql.sh
# 具体参数需在文件中修改
```

通过SSH将MySQL数据库复制到新服务器
```sh
mysqldump –add-drop-table –extended-insert –force –log-error=error.log -uUSER -pPASS OLD_DB_NAME | ssh -C user@newhost "mysql -uUSER -pPASS NEW_DB_NAME"
```
通过压缩的SSH隧道Dump一个MySQL数据库，将其作为输入传递给mysql命令，我认为这是迁移数据库到新服务器最快最好的方法。
