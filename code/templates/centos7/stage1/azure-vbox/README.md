# iManage SecOps Packer Build

## CentOS 7 - VirtualBox Edition

### Prerequiresites

* [VirtualBox 6.0](https://www.virtualbox.org/wiki/Download_Old_Builds_6_0)
* [VirtualBox Guest Addons](https://www.virtualbox.org/manual/ch04.html)
* [Packer 1.5](https://packer.io/intro/getting-started/install.html)
* [Ansible 2.9](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* GNU Make 3.8
  - MacOS: Install [Xcode](https://developer.apple.com/xcode/)
  - **or** MacOS: `brew install make` (installs in /usr/local/bin)
  - RedHat/CentOS: `sudo yum install make` (included in most base installs)
  - Ubuntu: `sudo apt-get install make` (included in most base installs)

### Build Configuration

As with the other Packer builds, this one uses the builtin Kickstart feature of the RedHat/CentOS Anaconda installer, it's fed a pointer to a Kickstart config (ks.cfg) on the boot command line.

The `kickflip` script is called by the Makefile and "flips" the config from one target to another. It reads in a base template, looks for the string `%%NETWORK%%` and replaces it with the one needed for the desired target. Details of `kickflip` are documented in the `shared/kickstart` README file, RTFM for more details on it.

### Image Build

To build, type 'make' in this directory, the default `all:` target runs the build. This **CAN NOT** be run from a virtualized Linux machine, they're missing the Intel VT-X BIOS extension by their very nature, it has to be run on *real steel*, as in locally. I use my Mac for this, it takes around 15 minutes to build this image.

Other Make targets:

* `clean:` removes intermediary build cache files
* `distclean:` removes intermediary files, the local ISO AND built images
* `validate:` runs Packer validate (this is always run before a build)
* `insepct:` runs Packer inspect
* `debug:` runs the default build along with the Packer -debug option

If the install file `CentOS-7-x86_64-Minimal-1908.iso` isn't found in the working directory it will be downloaded from a CentOS mirror site and cached for later builds. Downloading this file ahead of building saves download time.


### Automated Installation

The Packer build leverages the existing RedHat Kickstart automated installer configuration, the json build config file hands the name of the file, ks.cfg, to the Anaconda installer. This file is bundled up into an included floppy image on the VM which the boot command points to.

A log of the entire Kickstart post-build process is captured in `/var/log/impacker-ks-post.log`. In addition to that the following files are always captured by the Anaconda installer process:

* `/root/anaconda.log`
* `/root/original-ks.log`


### Packer Configuration

Packer uses a json based configuration, the file used for this particular build is vbox-config.json, edit that if you want to add additional items.


### Provisioners

As of this writing, the provisioners are:

```
"provisioners": [
{
  "type": "shell",
  "execute_command": "echo 'sysadmin' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
  "script": "../shared/scripts/ansible.sh"
},
{
  "type": "shell",
  "execute_command": "echo 'sysadmin' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
  "script": "../shared/scripts/cleanup.sh"
}
```

* `ansible.sh`: installs Ansible, if needed, and runs the default automation for a base image.
* `cleanup.sh`: performs various post-build cleanup routines including zeroing out empty disk.


### Variables

To be added


### VRDP Build Viewer

The VirtualBox VM is created in "headless mode" so there is no console available to monitor/debug the build process, if you want to view the "console" you will see something similar to this logged to the build shell session:

```
virtualbox-iso: The VM will be run headless, without a GUI. If you want to
virtualbox-iso: view the screen of the VM, connect via VRDP without a password to
virtualbox-iso: rdp://127.0.0.1:5956
```

At that point you can RDP to that port on localhost (127.0.0.1), log in using any username and no password, and you'll be able to view, and interact with, the Anaconda installer. The port changes for each build, you'll have to adjust to that.

Details on the VirtualBox VRDP extension are available [here](https://www.virtualbox.org/manual/ch07.html#vrde).


### Vagrant Integration

The Vagrant part currently does not work, feel free to fix that, the start of it is there. Ideally a `vagrant up` would launch the image.


### Notes

* Make sure the Kickstart file uses DHCP for the network boot protocol.
* If you get errors about virtual media being present and the build fails, go into the virtual media manager for VirtualBox and delete any that are disconnected cruft.
* The `Waiting on IP` part sits FOREVER on EVERYTHING, it's sort of a misleading message. While it is in fact waiting on an IP so Packer can connect and run the provisioners, failing after that can mean a number of things
  - Example: forgot to update passwords for all of the scripts being run? It'll sit there then fail.
    


*Note: as with all documentation these are provided best effort and are immediately out of date so take things here with a bucket of grains of salt. The code itself is the defacto "source of truth" for all things.*