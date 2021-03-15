
variable "vm_description" {
  type    = string
  default = "Ubuntu 18.04, x86-64, Stage 1 Base, Full CIS Level 1.1"
}

variable "vm_name" {
  type    = string
  default = "packer-ubuntu-18.04.5-stage2-full-cis"
}

variable "vm_version" {
  type    = string
  default = "0.1"
}

source "virtualbox-ovf" "virtualbox_stage2" {
  boot_command      = ["<tab><wait>", "<enter"]
  checksum          = "file:../packer-ubuntu-18.04.5.checksum"
  communicator      = "ssh"
  format            = "ovf"
  headless          = "false"
  keep_registered   = "true"
  output_directory  = "output-gold_image_stage2"
  shutdown_command  = "echo 'sysadmin' | sudo -S shutdown -P now"
  source_path       = "../output-gold_image/packer-ubuntu-18.04.5.ovf"
  ssh_password      = "ubuntu"
  ssh_username      = "ubuntu"
  skip_export       = false
  vm_name           = "packer-ubuntu-18.04.5-stage2"
  vrdp_bind_address = "127.0.0.1"
}

build {
  sources = ["source.virtualbox-ovf.virtualbox_stage2"]

  provisioner "shell" {
    execute_command = "echo 'sysadmin' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "../scripts/stage2.sh"
  }

  # Generate a vagrant box
  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "vagrant/stage2.box"
  }

  # Manifest file, only needed for vbox
  post-processor "manifest" {
    output     = "stage2.manifest"
    strip_path = false
  }

  # Checksums, only needed for vbox
  post-processor "checksum" {
    checksum_types = [ "sha256" ]
    output         = "stage2.checksum"
  }

}
