# Packer Build

## CentOS 7

All of the CentOS 7 related build templates are here.

## Contents

`vbox`: build for VirtualBox

`vsphere`: build for vSphere

`shared`: shared assets for all builds, things such as scripts and variable files are located here.

`code-templates`: Code templates to make adding new things easier and more standard

## Building

To build each one, cd into that directory and type 'make', as in:

`cd vsphere && make`

All of the Makefiles work the same way in each location with some minor differences based on the hypervisor being deployed to.

To build all of them, simply type 'make' in this folder. Note: this isn't working yet.



*Note: as with all documentation these are provided best effort and are immediately out of date so take things here with a bucket of grains of salt. The code itself is the defacto "source of truth" for all things.*
