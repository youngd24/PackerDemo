# iManage SecOps Packer Build

## CentOS 7 - vSphere Edition

### Prerequiresites

* VMware vSphere (our private cloud, built against DC6)
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

To build, simply type 'make' in this directory.

Other Make targets:

* `validate`: runs Packer validate (this is always run before a build)
* `insepct`: runs Packer inspect


### Automated Installation

The Packer build leverages the existing RedHat Kickstart automated installer configuration, the json build config file hands the name of the file, ks.cfg, to the Anaconda installer. This file is bundled up into an included floppy image on the VM which the boot command points to.

A log of the entire Kickstart post-build process is captured in `/var/log/impacker-ks-post.log`. In addition to that the following files are always captured by the Anaconda installer process:

* `/root/anaconda.log`
* `/root/original-ks.log`


### Packer Configuration

Packer uses a json based configuration, the file used for this particular build is vsphere-config.json, edit that if you want to add additional items.


### Networking

All of the iManage production data centers do NOT have DHCP services available so any virtual machine started must have a static IP if it needs networking access. This is normally fine for most provisioning situations however in the case of Packer the machine needs to be accessible via SSH (or WinRM for Windows) in order for it to be able to perform the post-build customization process.

To get around this the vSphere Kickstart configuration uses a static IP that's been reserved in IPAM for this build process. Once Packer has completed the last script it runs is one to clear out that static IP configuration.


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
  "type": "ansible-local",
  "playbook_file": "../shared/scripts/main.yml"
},
{
  "type": "shell",
  "execute_command": "echo 'sysadmin' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
  "script": "../shared/scripts/cleanup.sh"
},
{
  "type": "shell",
  "execute_command": "echo 'sysadmin' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
  "script": "../shared/scripts/ifcfg.sh"
}
```

* `ansible.sh`: Installs Ansible, if needed, and runs the default automation for a base image.
* `main.yml`: Ansible automation entry point.
* `cleanup.sh`: Performs various post-build cleanup routines including zeroing out empty disk.
* `ifcfg.sh`: Shell script that clears out the static IP configuration in the /etc/sysconfig/network-scripts directory.


### Console

As with all other vSphere VM's there is no console availble locally to view the installation process. Should the need be there for troubleshooting you'll need to use the Virtual Center console.


### Variables

TBD


### Notes

* As with `Waiting on IP` in other builders it's essentially useless for diagnostics and troubleshooting.
    


*Note: as with all documentation these are provided best effort and are immediately out of date so take things here with a bucket of grains of salt. The code itself is the defacto "source of truth" for all things.*