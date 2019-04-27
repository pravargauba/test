# README

=======alphaserver ===========

1.) Create one instance_server: alphaserver

2.) Install apache on alphaserver(so that we are able to access the UI) by typing: yum install httpd; service httpd start

3.) Just verify that the apache service is running: curl localhost:80 (you should see the HTML code of apache web page.)

4.) Make sure you have placed index.html attached in the repo, to the alpa-server's /var/www/html/ folder.

======== alphaclient =========

4.) Create one instance_client: alphaclient

5.) Now login to the aplhaclient(instance_client) machine. Make sure you are switched to root user to move further:

6.) Take a clone of this repo and go to test folder.(make sure you have git downloaded, yum -y install git)

Now our goal is to track /var/log/secure logs to get the number of attempts, and the hostname. For that we need to fetch out and parse the logs and store it in a variabe. Check out the script: logs.sh

Also, we need live monitoring/tracking of /var/log/secure log file, such that if it gets modified(means if any user is trying to ssh to the aplhaclient machine), it gives us the signal.
We will do it by inotify-wait command.(check out inotify-tools package) and download it by typing: 


7.)yum --enablerepo=epel -y install inotify-tools 

8.) Finally, create a script that notifies us by providing the script the location of the log file(/var/log/secure), as it has to be watched continously, which will execute ONLY when the log file changes. Kindly see the script named: notify_log_change.sh. Make sure this script is being run everytime, even when you logout, and it never stops. Type: nohup bash notify_log_change.sh &

That's it!! New changes/modifications in /var/log/secure are now continously being watched by notify_log_change.sh(as mentioned above) and the new metrics/changes are being captured in changes.txt.

9.) Now we also need to monitor the file "changes.txt", as it stores the latest ssh attempt metric, so as soon as it modifies(it means someone has tried to ssh into the server, and the new attempts would get increased by 1(and so on.. and so forth), hence, the latest attempt would be captured, and sent to the /var/www/html/index.html to the alpaserver). This whole logic is written in notify_changes.txt_change.sh. Also, please check that we are removing duplicate entries of the hostname as we are appending the metrics to /var/www/html/index.html (if we do not remove duplicate metrics, our alpaserver's UI will start showing same metrics again and again). 

10.) Edit the file: notify_changes.txt_change.sh and replace the <hostname_of_the_client_machine> by the hostname of the instance. Type command: hostname, and copy/paste the value to: sed -i '/<hostname_of_the_client_machine>/d' /var/www/html/index.html". We cannot do it automatically by replacing it in a variable, because in the script, we are running the command remotely after doing ssh in to the alphaserver, thus $hostname on the aplhaserver would be different than the $hostname of the current alphaclient machine on which you are logged on, so we need to edit this file manually.
We are using sed command to remove duplicate entries/metrics from the index.html file. Also, edit and place is <alpaserver_IP> in ssh command, and make sure you can ssh over to the alpaserver.(make sure pem key file path is correct.)
This logic is written in notify_changes.txt_change.sh. Make sure this script is being run everytime, even when you logout, and it never stops. Type: nohup bash notify_changes.txt_change.sh &


11.) Verifying if the setup is correctly setup::

A. Type the command:: jobs    ====>> to make sure and confirm that you have two background processes running at all times by the name of: notify_changes.txt_change.sh, and notify_log_change.sh.

B. Whether you are able to ssh to the alpaserver or not.

Finally, our whole setup is done! You can replicate the above setup on the number of alphaclient machines.(Repeat 4 to 11).



