##############################################################################
#
# kali2021.pkr.hcl
#
# Packer Kali 2021 builder
#
##############################################################################
#
# This configuration builds:
#   * vmware-iso
#   * virtualbox-iso
#
# To build them individually:
#   packer build -only=virtualbox-iso kali2021.pkr.hcl
#   packer build -only=vmware-iso kali2021.pkr.hcl
#
# To build all:
#   packer build kali2021.pkr.hcl
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

################
### ISO SETTINGS
################
variable "iso_url" {
  type    = string
  default = "https://cdimage.kali.org/kali-2021.1/kali-linux-2021.1-installer-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "265812bc13ab11d40c610424871bdf9198b9e7cad99b06540d96fac67dd704de"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

###############
### VM SETTINGS
###############
variable "vm_numcpus" {
  type    = string
  default = "1"
}

variable "vm_vram" {
  type    = string
  default = "2048"
}

variable "vm_disksize" {
  type    = string
  default = "81920"
}

####################
### VCENTER SETTINGS
####################
variable "vc_username" {
  type    = string
  default = "test"
}

variable "vc_password" {
  type    = string
  default = "test"
}

variable "vc_server" {
  type    = string
  default = "test"
}

variable "vc_datacenter" {
  type    = string
  default = "test"
}

variable "vc_datastore" {
  type    = string
  default = "test"
}

variable "vc_cluster" {
  type    = string
  default = "test"
}

##################
### OTHER SETTINGS
##################
variable "insecure_connection" {
  type    = string
  default = "true"
}

variable "ssh_password" {
  type    = string
  default = "kali"
}

variable "ssh_username" {
  type    = string
  default = "kali"
}

variable "http_directory" {
  type    = string
  default = "http"
}

variable "preseed_file" {
  type    = string
  default = "preseed.cfg"
}

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
source "virtualbox-iso" "src_virtualbox-iso" {
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
  headless                = false
  http_directory          = "${var.http_directory}"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = ["${var.iso_url}"]
  keep_registered         = "true"
  shutdown_command        = "${var.shutdown_command}"
  skip_export             = false
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_port                = 22
  ssh_timeout             = "10000s"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "packer-${var.kali_version}"
  disk_size               = "${var.vm_disksize}"

  vboxmanage              = [
                              ["modifyvm", "{{ .Name }}", "--memory", "${var.vm_vram}"],
                              ["modifyvm", "{{ .Name }}", "--cpus", "${var.vm_numcpus}"]
                            ]
}


###########################
# VMware vSphere ISO source
###########################
source "vsphere-iso" "src_vsphere-iso" {

  vcenter_server = "${var.vc_server}"
  username       = "${var.vc_username}"
  password       = "${var.vc_password}"
  cluster        = "${var.vc_cluster}"
  datacenter     = "${var.vc_datacenter}"
  datastore      = "${var.vc_datastore}"
  vm_name        = "packer-kali-${var.kali_version}"

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
  shutdown_command     = "${var.shutdown_command}"
  disk_controller_type = ["pvscsi"]
  guest_os_type        = "ubuntu64Guest"
  floppy_files         = ["${var.preseed_file}"]
  insecure_connection  = "${var.insecure_connection}"
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls             = ["${var.iso_url}"]
  notes                = "kali-${var.kali_version}"
  ssh_password         = "${var.ssh_password}"
  ssh_username         = "${var.ssh_username}"
  
  network_adapters {
    network      = ""
    network_card = "vmxnet3"
  }

  storage {
    disk_size             = "${var.vm_disksize}"
    disk_thin_provisioned = true
  }

}

##############################################################################
# BUILDS
##############################################################################
build {
  
  ####################
  # Build both sources
  ####################
  sources = [
              "source.virtualbox-iso.src_virtualbox-iso",
              "source.vsphere-iso.src_vsphere-iso"
            ]

  ##############
  # PROVISIONERS
  ##############

  # Common provisioners
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/update-apt.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/install-ansible.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/setup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/clear-network.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "scripts/ansible-bootstrap.yml"
  }

  ### VirtualBox only provisioners
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    only            = ["virtualbox-iso"]
    script          = "scripts/virtualbox-guest-additions.sh"
  }

  ### vSphere only provisioners
  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    only            = ["vmware-iso"]
    script          = "scripts/vmware-tools.sh"
  }

  ### LAST PROVISIONER
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
    only                = ["virtualbox-iso"]
    output              = "vagrant/packer-kali-${var.kali_version}.box"
  }

  # Manifest file, only needed for vbox
  post-processor "manifest" {
    output     = "packer-kali-${var.kali_version}.manifest"
    only       = ["virtualbox-iso"]
    strip_path = false
  }

  # Checksums, only needed for vbox
  post-processor "checksum" {
    checksum_types = [ "sha256" ]
    only           = ["virtualbox-iso"]
    output         = "packer-${var.kali_version}.checksum"
  }
}
