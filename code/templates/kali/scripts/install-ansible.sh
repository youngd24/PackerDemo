#!/bin/bash
###############################################################################
#
# ansible.sh
#
# Install and configure Ansible after Packer build
#
###############################################################################

echo "SCRIPT: ansible.sh"

# Install pip3
sudo apt-get -y install python3-pip

# Install Ansible
sudo pip install --upgrade ansible
