#!/bin/bash -

if [ `whoami` != 'root' ]; then
    echo "This script must be run as root."
    exit 1
fi



date

echo Rsyncing snapshotbackup from live
sudo -u plone_daemon rsync -a --delete rsync://colonialart.org/colonial_art_backup/snapshotbackups/ /var/local/plone-4.3/zeoserver/snapshotbackups/
sudo -u plone_daemon rsync -a --delete rsync://colonialart.org/colonial_art_backup/blobstoragesnapshots/ /var/local/plone-4.3/zeoserver/blobstoragesnapshots/

echo "Shutting down local plone"
# service haproxy stop
supervisorctl stop all

echo Restoring from remote snapshot copy
sudo -u plone_daemon /usr/local/plone-4.3/zeoserver/bin/snapshotrestore -n -q

echo Restarting local plone
supervisorctl start all
# sleep 60
# service haproxy start

echo Done
date
