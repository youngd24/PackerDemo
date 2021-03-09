#!/bin/bash
###############################################################################
#
# ansible.sh
#
# Install and configure Ansible after Packer build
#
###############################################################################

# Install pip3
sudo apt-get -y install python3-pip

# Install Ansible
sudo pip install --upgrade ansible
