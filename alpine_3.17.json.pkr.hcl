variable "http_ip" {
  type    = string
  default = "{{ .HTTPIP }}"
}

variable "proxmox" {
  type = object({
    iso_file = string
    node = string
    username = string
    password = string
    server = string
    storage_format = string
    storage_pool = string
    storage_pool_type = string
  })
}

source "proxmox" "alpine" {
  boot_command = [
    "root<enter><wait>",
    "ifconfig eth0 up<enter><wait>",
    "udhcpc -i eth0<enter><wait5>",
    "wget http://${var.http_ip}:{{ .HTTPPort }}/alpine<enter>",
    "setup-apkrepos -1<enter><wait>",
    "setup-alpine -f alpine<enter>",
    "<wait5>Abc1234<enter><wait>Abc1234<enter><wait15>",
    "y<enter><wait45>",
    "mount /dev/vg0/lv_root /mnt && echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config<enter><wait>",
    "chroot /mnt<enter>",
    "echo 'http://dl-cdn.alpinelinux.org/alpine/v3.17/main' > /etc/apk/repositories<enter>",
    "echo 'http://dl-cdn.alpinelinux.org/alpine/v3.17/community' >> /etc/apk/repositories<enter>",
    "apk update && apk upgrade && apk add qemu-guest-agent python3 openssh-sftp-server<enter><wait10>",
    "rc-update add qemu-guest-agent<enter><wait>",
    "sed -i '2iGA_PATH=/dev/vport1p1' /etc/init.d/qemu-guest-agent<enter><wait>",
    "exit<enter><wait>",
    "reboot<enter>"
  ]

  boot_wait    = "20s"
  cores        = 2

  disks {
    disk_size         = "2G"
    format            = "${var.proxmox_storage_format}"
    storage_pool      = "${var.proxmox_storage_pool}"
    storage_pool_type = "${var.proxmox_storage_pool_type}"
    type              = "scsi"
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
  ssh_password         = "Abc1234"
  ssh_timeout          = "15m"
  ssh_username         = "root"
  template_description = "Alpine, generated on ${timestamp()}"
  template_name        = "alpine-3.17"
  unmount_iso          = true
  username             = "${var.proxmox_username}"
}

build {
  sources = ["source.proxmox.alpine"]

  provisioner "ansible" {
    playbook_file = "./ansible/alpine.yml"
  }

}
