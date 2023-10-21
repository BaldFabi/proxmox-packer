packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "http_ip" {
  type    = string
  default = "{{ .HTTPIP }}"
}

variable "proxmox_iso_file" {
  type    = string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "proxmox_password" {
  type    = string
  default = ""
}

variable "proxmox_server" {
  type    = string
  default = ""
}

variable "proxmox_storage_format" {
  type    = string
  default = "raw"
}

variable "proxmox_storage_pool" {
  type    = string
  default = ""
}

variable "proxmox_username" {
  type    = string
  default = "service_packer@pve"
}

source "proxmox" "ubuntu-2204" {
  boot_command = [
    "c",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://${var.http_ip}:{{ .HTTPPort }}/'",
    "<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]
  boot_wait    = "10s"
  cores        = 2

  disks {
    disk_size    = "20G"
    format       = "${var.proxmox_storage_format}"
    storage_pool = "${var.proxmox_storage_pool}"
    type         = "scsi"
  }

  http_directory           = "config"
  http_port_max            = 12111
  http_port_min            = 12111
  insecure_skip_tls_verify = true
  iso_file                 = "${var.proxmox_iso_file}"
  memory                   = 2048

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  node                 = "${var.proxmox_node}"
  os                   = "l26"
  password             = "${var.proxmox_password}"
  proxmox_url          = "https://${var.proxmox_server}:8006/api2/json"
  ssh_password         = "Abc1234_"
  ssh_timeout          = "15m"
  ssh_username         = "ubuntu"
  template_description = "Ubuntu 22.04, generated on ${timestamp()}"
  template_name        = "ubuntu-22.04"
  unmount_iso          = true
  username             = "${var.proxmox_username}"
  vm_id                = 922
}

build {
  sources = ["source.proxmox.ubuntu-2204"]

  provisioner "shell" {
    inline = ["sudo apt-get update", "sudo apt-get install -y python3-pip", "sudo python3 -m pip install ansible"]
  }

  provisioner "ansible-local" {
    extra_arguments = ["-b"]
    playbook_dir    = "./ansible"
    playbook_file   = "./ansible/ubuntu_debian.yml"
  }

  provisioner "shell" {
    inline = ["sudo python3 -m pip uninstall -y ansible", "sudo sed -i '/^ubuntu/d' /etc/sudoers"]
  }

}
