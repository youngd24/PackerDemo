# Kali Packer VirtualBox-Vagrant

## Introduction

This project provides Packer and Vagrant configuration and supporting scripts for Kali Linux, to allow the creation of both standard Kali VMs and Vagrant boxes. Both VMware and Virtualbox are supported.

[https://www.packer.io/docs/builders/virtualbox
](https://www.packer.io/docs/builders/virtualbox)


# JSON Configuration File


There are more than 1 type of VirtualBox builders, this one uses an ISO as the input to build with. If the ISO isn't present in the loclal packer cache, it will be downloaded. If a checksum is specified for the iso, that will be validated as well.

```"type": "virtualbox-iso"```

At the end of the buid the VirtualBox iso builder normally will not export the vbox image out to disk, set to false to keep the export. They're places is output-virtualbox-iso with a VDI configuration file and a VMDK disk.

```"skip_export": false```

By default the builder runs in the background and will not launch vbox on the screen, this can be troublesome when diagnosing issues. Set this to false to see the actions taking place on the screen.

```"headless": false```

This is the boot command that Packer "types" into the installer, whatever kernel arguments are needed go in here. Not this is for a Kali Linux installation (preseed based) and **MUST** change based on the OS being Packer'd.

All of the <wait> statements aren't always necessary but helps with various timeout issues. I would leave them unless there's a reason not to.

```
"boot_command": [
    "<esc><wait>",
    "/install.amd/vmlinuz<wait>",
    " auto<wait>",
    " console-setup/ask_detect=false<wait>",
    " console-setup/layoutcode=us<wait>",
    " console-setup/modelcode=pc105<wait>",
    " debconf/frontend=noninteractive<wait>",
    " debian-installer=en_US<wait>",
    " fb=false<wait>",
    " initrd=/install.amd/initrd.gz<wait>",
    " kbd-chooser/method=us<wait>",
    " netcfg/choose_interface=eth0<wait>",
    " console-keymaps-at/keymap=us<wait>",
    " keyboard-configuration/xkb-keymap=us<wait>",
    " keyboard-configuration/layout=USA<wait>",
    " keyboard-configuration/variant=USA<wait>",
    " locale=en_US<wait>",
    " netcfg/get_domain=vm<wait>",
    " netcfg/get_hostname=kali<wait>",
    " grub-installer/bootdev=/dev/sda<wait>",
    " noapic<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg auto=true priority=critical",
    " -- <wait>",
    "<enter><wait>"
  ]
```

The name of the directory to serve HTTP content from, relative to the directory the JSON file is in.

```"http_directory": "http"```

How long to wait to type the boot_command in

```"boot_wait": "10s"```

Size of the virtual disk to create, in Kb

```"disk_size": 81920```

What command used to shut the machine down at the end

```"shutdown_command": "echo 'kali'|sudo -S shutdown -P now"```

OS gust type, use the correct Virtual Box option

```"guest_os_type": "Debian_64"```

The name of the guest additions, if any, to install

```"guest_additions_path": "VBoxGuestAdditions_{{.Version}}.iso"```

Location of the iso used to install. The first option is the name of the local directory/file to save it under, the other is the url to download the file from

```
"iso_urls": [
"iso/kali-linux-2021.1-installer-amd64.iso",
"https://cdimage.kali.org/kali-2021.1/kali-linux-2021.1-installer-amd64.iso"
]
```

The checksum for the iso file to validate.

```"iso_checksum": "sha256:265812bc13ab11d40c610424871bdf9198b9e7cad99b06540d96fac67dd704de"```

The credentials to use **AFTER** the installation for provisioners. Set this timeout to something large, like 10000 seconds, Packer will go into a loop for this amount waiting for ssh to become available. If the unattended installation fails you'll see Packer sit at the `waiting for ssh` for what feels like forever: 10000 seconds.

Also note: these credentials **MUST** exist inside the machine after the installation. The various OS installers have methods to add user accounts during installation.

```
"ssh_password": "kali",
"ssh_username": "kali",
"ssh_timeout": "10000s",
"ssh_port": 22,
```

VirtualBox settings for the VM

```
"vboxmanage": [
[
  "modifyvm",
  "{{.Name}}",
  "--memory",
  "4096"
],
[
  "modifyvm",
  "{{.Name}}",
  "--cpus",
  "1"
]
]
```


## Caveats
Currently this produces VMs with the kali standard credentials of `kali` and `kali`. This user has passwordless sudo access, in order to facilitate the ansible provisioners for both Packer and Vagrant. Once the box is built, the sudo configuration should be updated to enforce a password for sudo.

## Requirements
* Packer - [https://www.packer.io](https://www.packer.io)
* Virtualization Software
    * Virtualbox and the extension pack - [https://www.virtualbox.org](https://www.virtualbox.org)
    * VMware Workstation
* (optionally) Vagrant - [https://www.vagrantup.com](https://www.vagrantup.com)
    * If using VMware, you'll also need a license to the Vagrant VMware plugin.

## Usage
To build the virtual machine for both VMware and VirtualBox, run the following command:
```packer build packer.json```

To only build one or the other
```packer build -only=vmware-iso packer.json```
```packer build -only=virtualbox-iso packer.json```

## Vagrant

To build the Vagrant box, specify the `packer-vagrant.json` config file instead.

To add the resulting Vagrant box to your local Vagrant installation, use the following command:
```vagrant box add --name kalirolling builds/virtualbox-kali.box```
The `--force` flag can be used to overwrite a previously built box with the same name.

To instantiate a VM with Vagrant using the box you've just added, change into a directory containing an appropriate `Vagrantfile` and issue the `vagrant up` command. An example `Vagrantfile` is provided as part of this project.

# Credits
The preseed configuration file is borrowed and modified from the folks at Offensive Security, their examples can be found at [https://gitlab.com/kalilinux/recipes/kali-preseed-examples](https://gitlab.com/kalilinux/recipes/kali-preseed-examples).
