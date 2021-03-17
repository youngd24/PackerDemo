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

echo "Entering script stage2.sh"

echo "Running Ansible playbook cis.yml in /opt/cis"
cd /opt/cis && ansible-playbook cis.yml

echo "Leaving script stage2.sh"
