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
#sudo apt-get -y install python3-pip
#sudo apt-get -y install python-pip

# Install Ansible
#sudo pip install --upgrade ansible

sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible
