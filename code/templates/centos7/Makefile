###############################################################################
#
# Makefile
#
# Packer Makefile template
#
###############################################################################

PACKER = /usr/local/bin/packer
PACKER_FILE = config.json
PACKER_BUILD_OPTS = -timestamp-ui

.DEFAULT_GOAL := all

vbox:
	cd vbox && make validate

vsphere:
	cd vsphere && make validate

all: vbox vsphere

