###############################################################################
#
# Makefile
#
# Packer Makefile for VirtualBox
#
###############################################################################

PACKER = /usr/local/bin/packer
PACKER_FILE = secops-stage2-cis.json
PACKER_BUILD_OPTS = -timestamp-ui

.DEFAULT_GOAL := all

debug:
	$(PACKER) build $(PACKER_BUILD_OPTS) -debug $(PACKER_FILE)

build: 
	$(PACKER) build $(PACKER_BUILD_OPTS) $(PACKER_FILE)

validate:
	$(PACKER) validate $(PACKER_FILE)

inspect:
	$(PACKER) inspect $(PACKER_FILE)

all: validate build

clean:
	rm -fr output-virtualbox-ovf/
	rm -fr packer_cache

distclean: clean

