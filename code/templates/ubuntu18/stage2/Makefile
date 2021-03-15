###############################################################################
#
# Makefile
#
# Packer Makefile for VirtualBox and vSphere gold images
#
###############################################################################

# Packer options
# Tested with Packer 1.7.0
PACKER = /usr/local/bin/packer
PACKER_BUILD_OPTS = -timestamp-ui -color=false
PACKER_FILE := $(shell pwd)

GOLD_IMAGE_NAME = "stage2"
VBOX_BUILD      = "virtualbox-iso.$(GOLD_IMAGE_NAME)"
VSPHERE_BUILD   = "vsphere-iso.$(GOLD_IMAGE_NAME)"

.DEFAULT_GOAL := all

# Calls packer debug on vbox build
debug-vbox:
	@echo "*** Building (DEBUG) $(PACKER_FILE), opts: $(PACKER_BUILD_OPTS) ***"
	$(PACKER) build $(PACKER_BUILD_OPTS) -debug -only=$(VBOX_BUILD) $(PACKER_FILE)

# Build vmware vsphere image
vsphere:
	@echo "*** Building vsphere, opts: $(PACKER_BUILD_OPTS) ***"
	$(PACKER) build -only=$(VSPHERE_BUILD) $(PACKER_BUILD_OPTS) $(PACKER_FILE)

# Build vbox image
vbox:
	@echo "*** Building vbox, opts: $(PACKER_BUILD_OPTS) ***"
	$(PACKER) build $(PACKER_BUILD_OPTS) -only=$(VBOX_BUILD) $(PACKER_FILE)

# Build all, clean first
build: clean
	@echo "*** Build all ***"
	@make vbox

# packer validate
validate:
	@echo "*** Validating $(PACKER_FILE) ***"
	$(PACKER) validate $(PACKER_FILE)

# packer inspect
inspect:
	$(PACKER) inspect $(PACKER_FILE)

# Clean built images, locally, but preserve iso for builds
clean:
	@echo "Cleaning..."
	rm -fr vagrant/*.box
	find . -type d -name .vagrant | xargs rm -fr
	rm -f *.log
	rm -fr output-gold_image*
	rm -fr *.checksum
	rm -fr *.manifest

# Clean, everything including iso's
distclean: clean
	@echo "Making really (dist) clean..."
	rm -fr packer_cache/

# default build target
all: validate build
