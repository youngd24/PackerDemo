#!/bin/bash -eux
###############################################################################
#
# stage2.sh
#
# Second stage OS build, this hardens the image
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
#cd /opt && ansible-playbook rhel7-cis.yml

echo "Leaving script $0"
