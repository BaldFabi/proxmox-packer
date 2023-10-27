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

source "proxmox" "debian-12" {
  boot_command = ["<esc><wait>", "auto url=http://${var.http_ip}:{{ .HTTPPort }}/debian_bookworm.cfg<enter>"]
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
  ssh_username         = "root"
  template_description = "Debian 12, generated on ${timestamp()}"
  template_name        = "debian-12"
  unmount_iso          = true
  username             = "${var.proxmox_username}"
  vm_id                = 912
}

build {
  sources = ["source.proxmox.debian-12"]

  provisioner "ansible" {
    playbook_file = "./ansible/ubuntu_debian.yml"
  }

}
