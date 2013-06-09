#!/bin/bash

umask 066

HOST=dbs
USER=root
PASS=root

# DB=db1 db2 ...
DB=dbname
DATE=$(date "+%Y-%m-%d")
BACKDIR=/home/rails/backup
KEEP="90 days"

# create dir if not exists
if ! [ -d $BACKDIR ]; then
  mkdir $BACKDIR
fi

# dump database
cd $BACKDIR
mysqldump -h$HOST -u$USER -p$PASS $DB | gzip > mysql-$DATE.sql.gz

# remove old files
rm -rf /home/rails/backup/mysql-`date --date="$KEEP ago" "+%Y-%m-%d"`.sql.gz

# for create test file
# ruby -rubygems -e 'require "active_support/all"; 31.times.each {|i| `touch mysql-#{i.days.ago.to_date.to_s :db}.sql.tgz`}'
