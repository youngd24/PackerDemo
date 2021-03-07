##############################################################################
#
# kali2021-vbox.pkr.hcl
#
##############################################################################
#
#
#
##############################################################################


##############################################################################
#
# VARIABLES
#
##############################################################################

# Internal web server directory
variable "http_directory" {
  type    = string
  default = "http"
}

variable "ssh_password" {
  type    = string
  default = "kali"
}

variable "ssh_username" {
  type    = string
  default = "kali"
}

##############################################################################
#
# SOURCES
#
##############################################################################

# ISO based source
source "virtualbox-iso" "iso-build" {
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
                              " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg auto=true priority=critical",
                              " -- <wait>",
                              "<enter><wait>"
                            ]
  boot_wait               = "10s"
  disk_size               = 81920
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Debian_64"
  headless                = false
  http_directory          = "${var.http_directory}"
  iso_checksum            = "sha256:265812bc13ab11d40c610424871bdf9198b9e7cad99b06540d96fac67dd704de"
  iso_urls                = ["iso/kali-linux-2021.1-installer-amd64.iso", "https://cdimage.kali.org/kali-2021.1/kali-linux-2021.1-installer-amd64.iso"]
  keep_registered         = "true"
  shutdown_command        = "echo 'kali'|sudo -S shutdown -P now"
  skip_export             = false
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_port                = 22
  ssh_timeout             = "10000s"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "4096"], ["modifyvm", "{{ .Name }}", "--cpus", "1"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "packer-kali-2021"
}

##############################################################################
#
# BUILDS
#
##############################################################################

build {
  
  sources = [ "source.virtualbox-iso.iso-build" ]

  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/update-apt.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/virtualbox-guest-additions.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/install-ansible.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/setup.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "scripts/ansible-bootstrap.yml"
  }

  provisioner "shell" {
    execute_command = "echo 'kali' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/cleanup.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "vagrant/<no value>-kali-2021.1.box"
  }
  post-processor "manifest" {
    output     = "packer-kali-2021.manifest"
    strip_path = false
  }

  post-processor "checksum" {
    checksum_types = [ "sha256" ]
    output         = "packer-kali-2021.checksum"
  }
}
