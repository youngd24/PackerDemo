#!/bin/bash -eux
###############################################################################
#
# cleanup.sh
#
# Script to perform various housecleaning activities before reboot
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

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

echo "Leaving script $0"
