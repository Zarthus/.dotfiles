CR=`sudo checkrestart`
CR_EXIT=$?

FILETOWRITE=/root/cronjobs/checkrestart.log

if [ "$CR_EXIT" != "0" ]; then
    echo "The checkrestart utility failed to execute successfully." > $FILETOWRITE
    echo "The checkrestart utility failed to execute successfully." > /etc/update-motd.d/checkrestart.log
else
    echo "$CR" > $FILETOWRITE
    echo "$CR" > /etc/update-motd.d/checkrestart.log
fi
