##############################################################################
#
# kali.pkr.hcl
#
# Packer Kali builder
#
##############################################################################
#
# This configuration builds gold images for:
#   * vsphere-iso
#   * virtualbox-iso
#
# To build them individually:
#   packer build -only=virtualbox-iso.gold_image .
#   packer build -only=vsphere-iso.gold_image .
#
# To build all:
#   packer build .
#
##############################################################################


##############################################################################
# VARIABLES
##############################################################################

# kali version to use
variable "kali_version" {
  type    = string
  default = "2021.1"
}

# Should vbox run headless
# normally this should be true for background operations
# set to false to troubleshoot installer issues
variable "vbox_headless" {
  type    = bool
  default = false
}

# At the end of the build for vbox, should the VM used stay in vbox or
# be removed. Useful to keep around to turn it on to troubleshoot
# issues from the installation.
variable "vbox_keep_registered" {
  type    = bool
  default = true
}

################
### ISO SETTINGS
################

# where is the iso used to install
variable "iso_url" {
  type    = string
  default = "https://cdimage.kali.org/kali-2021.1/kali-linux-2021.1-installer-amd64.iso"
}

# checksum for the above iso
variable "iso_checksum" {
  type    = string
  default = "265812bc13ab11d40c610424871bdf9198b9e7cad99b06540d96fac67dd704de"
}

# checksum type, usually sha256 but sometimes md5
variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

###############
### VM SETTINGS
###############

# how many cpu's should the machine have
variable "vm_numcpus" {
  type    = string
  default = "1"
}

# ram in the vm, use the minimal needed
variable "vm_vram" {
  type    = string
  default = "1024"
}

# vm disk size, again, use the minimum needed
variable "vm_disksize" {
  type    = string
  default = "81920"
}

# this provision the vm disk?
# only applicable to the vmware vsphere build
variable "vm_thinpro" {
  type    = bool
  default = true
}

# VM network adapter type
variable "vm_vnic" {
  type    = string
  default = "vmxnet3"
}

# VM network 
variable "vm_vnet" {
  type    = string
  default = "PROD"
}

###########################
### VIRTUAL CENTER SETTINGS
###########################

# Virtual Center usename to connect as
variable "vc_username" {
  type    = string
}

# Virtual Center password to use
variable "vc_password" {
  type    = string
}

# Virtual Center server to connect to
variable "vc_server" {
  type    = string
}

# Virtual Center data center to create VM in
variable "vc_datacenter" {
  type    = string
}

# Virtual Center datastore to use for the vm
variable "vc_datastore" {
  type    = string
}

# Virtual Center cluster to use
# these templates currently do not support standalone
# esx host targeted builds
variable "vc_cluster" {
  type    = string
}

# Should we allow a non-https connection to vcenter?
variable "vc_insecure" {
  type    = string
}

##################
### OTHER SETTINGS
##################

# ssh username to use for provisioners
# remember, your OS install MUST create this account
# or the post-install tasks WILL fail
variable "ssh_username" {
  type    = string
  default = "kali"
}

# ssh password to use for provisioners
variable "ssh_password" {
  type    = string
  default = "kali"
}

# local Packer HTTP directory to host files
variable "http_directory" {
  type    = string
  default = "http"
}

# The installer preseed file, this normally goes in the
# http directory (which we do below)
variable "preseed_file" {
  type    = string
  default = "preseed.cfg"
}

# Command to shutdown the machine at the end
variable "shutdown_command" {
  type    = string
  default = "echo 'kali'|sudo -S shutdown -P now"
}


##############################################################################
# SOURCES
##############################################################################

#######################
# VirtualBox ISO source
#######################
source "virtualbox-iso" "gold_image" {
  boot_command            = [
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
                              " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} auto=true priority=critical",
                              " -- <wait>",
                              "<enter><wait>"
                            ]
  boot_wait               = "10s"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Debian_64"
  headless                = "${var.vbox_headless}"
  http_directory          = "${var.http_directory}"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = ["${var.iso_url}"]
  keep_registered         = "${var.vbox_keep_registered}"
  shutdown_command        = "${var.shutdown_command}"
  skip_export             = false
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_port                = 22
  ssh_timeout             = "10000s"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "packer-kali-${var.kali_version}"
  disk_size               = "${var.vm_disksize}"

  vboxmanage              = [
                              ["modifyvm", "{{ .Name }}", "--memory", "${var.vm_vram}"],
                              ["modifyvm", "{{ .Name }}", "--cpus", "${var.vm_numcpus}"]
                            ]
}


###########################
# VMware vSphere ISO source
###########################
source "vsphere-iso" "gold_image" {

  # Virtual Center settings
  vcenter_server = "${var.vc_server}"
  username       = "${var.vc_username}"
  password       = "${var.vc_password}"
  cluster        = "${var.vc_cluster}"
  datacenter     = "${var.vc_datacenter}"
  datastore      = "${var.vc_datastore}"

  # VM general settings
  vm_name              = "packer-kali-${var.kali_version}"
  CPUs                 = "${var.vm_numcpus}"
  RAM                  = "${var.vm_vram}"
  RAM_reserve_all      = true
  boot_command         = [
                          "<enter><wait><f6><wait><esc><wait>",
                          "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                          "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                          "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                          "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                          "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                          "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                          "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                          "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                          "<bs><bs><bs>",
                          "/install/vmlinuz",
                          " initrd=/install/initrd.gz",
                          " priority=critical",
                          " locale=en_US",
                          " file=/media/${var.preseed_file}",
                          "<enter>"
                        ]

  # VM network settings
  network_adapters {
    network      = "${var.vm_vnet}"
    network_card = "${var.vm_vnic}"
  }

  # VM disk settings
  storage {
    disk_size             = "${var.vm_disksize}"
    disk_thin_provisioned = "${var.vm_thinpro}"
  }

  # Misc settings
  shutdown_command     = "${var.shutdown_command}"
  disk_controller_type = ["pvscsi"]
  guest_os_type        = "ubuntu64Guest"
  floppy_files         = ["${var.preseed_file}"]
  insecure_connection  = "${var.vc_insecure}"
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls             = ["${var.iso_url}"]
  notes                = "packer-kali-${var.kali_version}"
  ssh_password         = "${var.ssh_password}"
  ssh_username         = "${var.ssh_username}"
}

##############################################################################
# BUILDS
##############################################################################
build {
  
  ####################
  # Build both sources
  ####################
  sources = [
              "source.virtualbox-iso.gold_image",
              "source.vsphere-iso.gold_image"
            ]

  ##############
  # PROVISIONERS
  ##############

  #####################
  # Common provisioners
  #####################

  # Update the machine first thing
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/update-apt.sh"
  }

  # Install Ansible
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/install-ansible.sh"
  }

  # Some final setup of the machine
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/setup.sh"
  }

  # Clears the network config for a fresh boot
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/clear-network.sh"
  }

  # kick to Ansible for configuration on first-boot
  provisioner "ansible-local" {
    playbook_file = "scripts/ansible-bootstrap.yml"
  }

  ################################
  ### VirtualBox only provisioners
  ################################

  # Install the vbox guest additions
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    only            = ["virtualbox-iso.gold_image"]
    script          = "scripts/virtualbox-guest-additions.sh"
  }

  #############################
  ### vSphere only provisioners
  #############################

  # Install vmware tools (open-vm-tools)
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    only            = ["vsphere-iso.gold_image"]
    script          = "scripts/vmware-tools.sh"
  }

  ####################
  ### LAST PROVISIONER
  ####################
  
  # The very last provisioner
  # This should leave the image in a usable state
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/cleanup.sh"
  }


  #################
  # POST-PROCESSORS
  #################

  # Generate a vagrant box
  post-processor "vagrant" {
    keep_input_artifact = true
    only                = ["virtualbox-iso.gold_image"]
    output              = "vagrant/packer-kali-${var.kali_version}.box"
  }

  # Manifest file, only needed for vbox
  post-processor "manifest" {
    output     = "packer-kali-${var.kali_version}.manifest"
    only       = ["virtualbox-iso.gold_image"]
    strip_path = false
  }

  # Checksums, only needed for vbox
  post-processor "checksum" {
    checksum_types = [ "sha256" ]
    only           = ["virtualbox-iso.gold_image"]
    output         = "packer-kali-${var.kali_version}.checksum"
  }
}