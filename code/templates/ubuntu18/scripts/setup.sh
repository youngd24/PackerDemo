#!/bin/bash -eux
###############################################################################
#
# setup.sh
#
# Basic OS setup after Packer build, called as a provisioner
#
###############################################################################

echo "SCRIPT: setup.sh"

# sudoers file
echo "ubuntu        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

# Fix for login issues related to lack of randomness
sudo apt-get install -y haveged
sudo systemctl enable haveged
