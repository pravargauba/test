#!/bin/bash
watchfile=/home/ec2-user/test/changes.txt
while : ; do
        inotifywait $watchfile|while read path action file; do
               ssh -i /home/ec2-user/.ssh/abcxyz.pem ec2-user@<alpaserver_IP> "sed -i '/<hostname_of_the_machine>/d' /var/www/html/index.html"
               cat /home/ec2-user/test/changes.txt | ssh -i /home/ec2-user/.ssh/abcxyz.pem ec2-user@<alpaserver_IP> "cat >> /var/www/html/index.html"
        done
done
exit 0
