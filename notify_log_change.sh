#!/bin/bash
watchlogfile=/var/log/secure
scripttoexecute=/home/ec2-user/test/logs.sh
changes=/home/ec2-user/test/changes.txt
while : ; do
        inotifywait $watchlogfile|while read path action file; do
                bash $scripttoexecute > $changes
        done
done
exit 0
