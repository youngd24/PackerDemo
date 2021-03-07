# Kali Packer VirtualBox-Vagrant

## Introduction

This project provides Packer and Vagrant configuration and supporting scripts for Kali Linux, to allow the creation of both standard Kali VMs and Vagrant boxes. Both VMware and Virtualbox are supported.

[https://www.packer.io/docs/builders/virtualbox
](https://www.packer.io/docs/builders/virtualbox)


## Caveats
Currently this produces VMs with the kali standard credentials of `kali` and `kali`. This user has passwordless sudo access, in order to facilitate the ansible provisioners for both Packer and Vagrant. Once the box is built, the sudo configuration should be updated to enforce a password for sudo.

## Requirements
* Packer - [https://www.packer.io](https://www.packer.io)
* Virtualbox and the extension pack - [https://www.virtualbox.org](https://www.virtualbox.org)
* Vagrant - [https://www.vagrantup.com](https://www.vagrantup.com)


## Usage
To build the virtual machine for VirtualBox, run the following command:

```make vbox```

To build the virtual machine for vSphere, run the following command:

```make vsphere```

To build both, run:

```make```