###############################################################################
#
# Makefile
#
# Packer Makefile for VirtualBox
#
###############################################################################

PACKER = /usr/local/bin/packer
PACKER_FILE = vbox-config.json
PACKER_BUILD_OPTS = -timestamp-ui

.DEFAULT_GOAL := all

kickflip:
	../../shared/kickstart/kickflip vbox

debug:
	$(PACKER) build $(PACKER_BUILD_OPTS) -debug $(PACKER_FILE)

build: kickflip
	$(PACKER) build $(PACKER_BUILD_OPTS) $(PACKER_FILE)

validate:
	$(PACKER) validate $(PACKER_FILE)

inspect:
	$(PACKER) inspect $(PACKER_FILE)

all: validate build

clean:
	rm -fr packer_cache
	rm -fr centos7-base-virtualbox.box
	rm -fr output-virtualbox-iso

distclean: clean
	rm -fr CentOS*.iso

