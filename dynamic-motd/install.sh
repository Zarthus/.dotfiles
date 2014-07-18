#!/bin/bash
# This file installs the requirements for a dynamic MOTD, and makes it work on Debian Systems.
# This file requires sudoer access
# This installation is licensed under MIT, but the original author's files are licensed under GNU General Public License.

sudo apt-get install update-notifier-common figlet

sudo mkdir /etc/update-motd.d/
sudo mv etc/update-motd.d/ /etc/update-motd.d/
sudo chmod +x /etc/update-motd.d/*
sudo rm /etc/motd
sudo ln -s /var/run/motd /etc/motd