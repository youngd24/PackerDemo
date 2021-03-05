###############################################################################
#
# Makefile
#
# Packer Makefile for VirtualBox
#
###############################################################################


.DEFAULT_GOAL := all

all: distclean

clean:
	@echo "Cleaning..."
	rm -fr vagrant/*.box
	rm -fr output-virtualbox-iso

distclean: clean
	@echo "Making really clean..."
	rm -fr packer_cache
