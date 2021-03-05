#!/bin/bash -eux
###############################################################################
#
# 
#
# 
#
###############################################################################
#
# NOTES:
#
###############################################################################
#
# TODO:
#
###############################################################################

echo "Entering script $0"

echo "Updating CA certs and trusts (ignore any ca package errors)"
yum -y install ca-certificates
update-ca-trust

echo "Git clone CIS repo"
git clone https://github.com/MindPointGroup/RHEL7-CIS.git /opt/RHEL7-CIS

echo "Installing /opt/rhel7-cis.yml"
cat << END > /opt/rhel7-cis.yml

- name: Harden Server
  hosts: localhost
  connection: local
  become: yes

  roles:
    - RHEL7-CIS

END

echo "Leaving script $0"
