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
DEST="/opt"
CISDIR="/opt/$CIS_VER"

# Copy the CIS source to /opt
echo "Copying CIS source files ($SRC to $DEST)"
sudo cp -R $SRC $DEST

# symlink the current CIS version to the version deployed
echo "Setting up CIS version ($DEST to $CISDIR)"
sudo ln -s $CISDIR "$DEST/cis"