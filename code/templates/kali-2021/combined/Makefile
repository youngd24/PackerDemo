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

build: clean 
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
	rm -fr packer-kali-2021.checksum
	rm -fr packer-kali-2021.manifest

distclean: clean
	@echo "Making really clean..."
	rm -fr packer_cache/
	rm -fr .vagrant/
