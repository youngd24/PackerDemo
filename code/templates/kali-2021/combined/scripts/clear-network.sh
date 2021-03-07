#!/bin/bash
###############################################################################
#
# clear-network.sh
#
# Clears network configuration
#
###############################################################################

sudo rm -rf /etc/netplan/*.yaml
sudo netplan apply
