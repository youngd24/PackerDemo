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

echo "Running CIS playbook rhel7-cis.yml in /opt"
cd /opt && ansible-playbook rhel7-cis.yml

echo "Leaving script $0"
