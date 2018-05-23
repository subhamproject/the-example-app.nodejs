#!/bin/bash -xe
#cd $(dirname $0)
TEMP_DIR="$WORKSPACE/tmp"
[ -d $TEMP_DIR ] || mkdir -p $TEMP_DIR
FILES=$(git diff --name-only HEAD~1 HEAD|grep -v Deployment.sh)

if [ -n "${FILES}" ];then
  for I in $(echo "${FILES}"|xargs -n1 basename)
 do
 file=$(find . -name $I)
   if [ -n "${file}" ]
   then
   echo "File \"${file}\" found,Copying to temp dir $TEMP_DIR!"
   cp -pr $file $TEMP_DIR
   elif [ -z "${file}" ];then
   echo "Could not find file \"$I\",As this file was deleted in last commit..Skipping!"
   fi
 done
else
echo "No Changes were done in last commit!"
fi
cd $TEMP_DIR
[ `ls -1|wc -l` -ge 1 ] &&  tar -zcvf /tmp/archive-name.tar.gz .  >> /dev/null
[ $? -eq 0 ] &&  tar -zxvf /tmp/archive-name.tar.gz -C /tmp/mytest >> /dev/null
chown -R subham:subham /tmp/mytest >> /dev/null
rm -rf $TEMP_DIR
rm -rf /tmp/archive-name.tar.gz
