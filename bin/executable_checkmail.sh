#!/bin/sh

STATE=`nmcli networking connectivity`

if [ $STATE = 'full' ]
then
#    ~/.local/bin/msmtp-runqueue.sh
    mbsync -a
    notmuch new
    /usr/bin/afew -tn
    notmuch tag -inbox tag:inbox AND tag:lists
    exit 0

fi
echo "No Internet connection!"
exit 0
