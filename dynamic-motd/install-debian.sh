#!/bin/bash
# This file installs the requirements for a dynamic MOTD, and makes it work on Debian Systems.
# This file requires sudoer access
# This installation is licensed under MIT, but the original author's files are licensed under GNU General Public License.

sudo apt-get install update-notifier-common figlet debian-goodies

echo "Making a backup in ~/backup-motd"
sudo mkdir -p ~/backup-motd
sudo cp /etc/motd ~/backup-motd

echo "Creating /etc/update-motd.d/, moving required files and giving them execution rights."
sudo mkdir /etc/update-motd.d/
sudo mv etc/update-motd.d/ /etc/update-motd.d/
sudo chmod +x /etc/update-motd.d/*
sudo rm /etc/motd

echo "Symlink created"
sudo ln -s /var/run/motd /etc/motd

echo "Done!"