#!/bin/bash
###############################################################################
#
# update-apt.sh
#
# Update the OS to current 
#
###############################################################################

# Update the apt cache
sudo apt-get update

# Upgrade all packages installed
sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" dist-upgrade -yq
