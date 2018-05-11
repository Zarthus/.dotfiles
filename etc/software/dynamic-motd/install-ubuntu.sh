#!/bin/bash
# This file installs the requirements for a dynamic MOTD, and makes it work on Debian Systems.
# This file requires sudoer access
# This installation is licensed under MIT, but the original author's files are licensed under GNU General Public License.

# It has been brought to my attention that Ubuntu already has this set up, I cannot guarantee this working
# as I don't own a copy of ubuntu. But in either way. This might be a way to set it up.

sudo apt-get install update-notifier-common figlet debian-goodies

echo "Making backup in ~/backup-motd"
sudo mkdir -p ~/backup-motd/update-motd.d/
sudo cp /etc/update-motd.d/* ~/backup-motd/update-motd.d/

if [ -a "/etc/motd" ]; then
    sudo cp /etc/motd ~/backup-motd/motd
    sudo rm /etc/motd
fi

echo "Making required directories, moving requires files and giving them execution rights."
mkdir -p /etc/update-motd.d/
sudo mv etc/ /etc/update-motd.d/
sudo chmod +x /etc/update-motd.d/*

echo "Symlink created"
sudo ln -s /var/run/motd /etc/motd

echo "Done!"
