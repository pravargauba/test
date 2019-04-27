attempts=$(egrep "Invalid|Failure|Accepted" /var/log/secure | uniq -c | wc -l)
hostname=$(hostname)
echo "<p>$attempts ssh log-in attempts were made at $hostname</p>"
