###############################################################################
#
# Makefile
#
# Packer Makefile for VirtualBox
#
###############################################################################

PACKER = /usr/local/bin/packer
PACKER_FILE = kali2021.pkr.hcl
PACKER_BUILD_OPTS = -timestamp-ui -color=false

.DEFAULT_GOAL := all

debug:
	@echo "Building (** debug **) $(PACKER_FILE), opts: $(PACKER_BUILD_OPTS)"
	$(PACKER) build $(PACKER_BUILD_OPTS) -debug $(PACKER_FILE)

build-vmware:
	@echo "Building vmware, opts: $(PACKER_BUILD_OPTS)"
	$(PACKER) build -only=vmware-iso $(PACKER_BUILD_OPTS) $(PACKER_FILE)

build-virtualbox:
	@echo "Building vmware, opts: $(PACKER_BUILD_OPTS)"
	$(PACKER) build -only=virtualbox-iso $(PACKER_BUILD_OPTS) $(PACKER_FILE)

build: clean build-virtualbox build-vmware
	@echo "Build all"

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
	rm -fr *.checksum
	rm -fr *.manifest

distclean: clean
	@echo "Making really (dist) clean..."
	rm -fr packer_cache/
	rm -fr .vagrant/
