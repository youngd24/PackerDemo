###############################################################################
#
# Makefile
#
# Packer Makefile for vSphere
#
###############################################################################

PACKER = /usr/local/bin/packer
PACKER_FILE = vsphere-config.json
PACKER_BUILD_OPTS = -timestamp-ui

.DEFAULT_GOAL := all

kickflip:
	../../shared/kickstart/kickflip vsphere

build: kickflip
	$(PACKER) build $(PACKER_BUILD_OPTS) $(PACKER_FILE)

validate:
	$(PACKER) validate $(PACKER_FILE)

inspect:
	$(PACKER) inspect $(PACKER_FILE)

all: validate build
