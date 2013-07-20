#!/bin/sh
counter=1
root=mypict
resolution=400x300
for i in `ls -1 $1/*.jpg`; do
  echo "Now working on $i"
  convert -resize $resolution $i ${root}_${counter}.jpg
  counter=`expr $counter + 1`
done

# 使用
# picturename.sh /path/to/pictdir
# 会按照400×300比例缩放，生成mypict_1.jpg, mypict_2.jpg之类的文件
