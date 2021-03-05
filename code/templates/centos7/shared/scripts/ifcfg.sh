#!/bin/bash -eux
###############################################################################
#
# ifcfg.sh
#
# Script to set the interface back to DHCP from static that's needed
# for Packer & Ansible to work
#
###############################################################################
#
# NOTES:
#  - It's hardcoded to ens192, it's assumed this will work on the current
#    private cloud (vmware) we run
#  - It has to be run as root
#
###############################################################################
#
# TODO:
#
#  - Add error detection & correction
#  - Allow it to work for other interfaces
#  - Maybe convert it to use nmcli to make the settings
#
###############################################################################

echo "Entering script $0"

# Get the interface UUID for NetworkManager
IF_UUID=$(/bin/nmcli connection show --active | grep -v UUID | grep ens192 | awk '{print $2}')
IF_NAME="ens192"
IF_ZONE="internal"

echo "Setting interface $IF_NAME, UUID $IF_UUID to zone $IF_ZONE"

# A very basic DHCP file, testing on CentOS 7.x, likely works on RHEL 7.x
# IPV6 sux
cat << END > /etc/sysconfig/network-scripts/ifcfg-ens192
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=no
IPV6_DEFROUTE=no
IPV6_FAILURE_FATAL=no
NAME=$IF_NAME
DEVICE=$IF_NAME
UUID=$IF_UUID
ONBOOT=no
ZONE=$IF_ZONE
END

echo "Leaving script $0"
