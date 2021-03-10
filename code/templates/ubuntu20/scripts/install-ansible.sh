#!/bin/bash
###############################################################################
#
# install-ansible.sh
#
# Install and configure Ansible after Packer build
#
###############################################################################

echo "SCRIPT: install-ansible.sh"

# Install pip3
sudo apt-get -y install python3-pip

# Install Ansible
sudo pip3 install --upgrade ansible
