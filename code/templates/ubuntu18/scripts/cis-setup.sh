#!/bin/bash -eux
###############################################################################
#
# cis_setup.sh
#
# Setup for CIS hardening
#
###############################################################################

echo "SCRIPT: cis-setup.sh"

CIS_VER="cis_ubuntu_18.04"

SRC="/tmp/$CIS_VER"
CISDIR="/opt/cis"

# Copy the CIS source to /opt
# A Packer provisioner copied the files there already
echo "Copying CIS source files ($SRC to $CISDIR)"
sudo cp -R $SRC $CISDIR

