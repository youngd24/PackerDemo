###############################################################################
#
# Makefile
#
# Packer Makefile for VirtualBox
#
###############################################################################

PACKER = /usr/local/bin/packer
PACKER_FILE = kali2021-vbox-iso.json
PACKER_BUILD_OPTS = -timestamp-ui

.DEFAULT_GOAL := all

debug:
	@echo "Building (** debug **) $(PACKER_FILE), opts: $(PACKER_BUILD_OPTS)"
	$(PACKER) build $(PACKER_BUILD_OPTS) -debug $(PACKER_FILE)

build: 
	@echo "Building $(PACKER_FILE), opts: $(PACKER_BUILD_OPTS)"
	$(PACKER) build $(PACKER_BUILD_OPTS) $(PACKER_FILE)

validate:
	@echo "Validating $(PACKER_FILE)"
	$(PACKER) validate $(PACKER_FILE)

inspect:
	$(PACKER) inspect $(PACKER_FILE)

all: validate build

clean:
	@echo "Cleaning..."
	rm -fr vagrant/*.box
	rm -fr output-virtualbox-iso

distclean: clean
	@echo "Making really clean..."
	rm -fr packer_cache
