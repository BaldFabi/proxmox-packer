# Proxmox Packer template provisioning

This repository provides you configuration files to generate templates for [Debian 10](debian_10.json), [Debian 11](debian_11.json), [Debian 11 k3s node](debian_11_k3s_node.json), [Ubuntu 20.04](ubuntu_20.04.json) and [Alpine (made for 3.13)](alpine_3.13.json) on your Proxmox host.

## Vars

| Var                       | Description                                                                        | Default            |
| ------------------------- | ---------------------------------------------------------------------------------- | ------------------ |
| proxmox_server            | Hostname (fqdn) or ip address of the proxmox server (used for api access)          |                    |
| proxmox_username          | Username with enough rights to create machines and templates                       | service_packer@pve |
| proxmox_password          | Password of the given user                                                         |                    |
| proxmox_node              | The node on which the template should be created                                   |                    |
| proxmox_storage_pool      | The storage pool in which the drives will be placed in                             |                    |
| proxmox_storage_pool_type | The storage pool type                                                              | directory          |
| proxmox_storage_format    | The format of the default disk                                                     | qcow2              |
| proxmox_iso_file          | The path to you iso file (your-storage:anyfolder/debian-10.10.0-amd64-netinst.iso) |                    |
| http_ip                   | The optional IP address for the vm to access the Packer http server                | .HTTPIP            |

> If you try to run Packer within WSL2 the port will only be opened on localhost. Use a container instead to open it on 0.0.0.0 and set the `http_ip` to the ip address of your physical interface

## Important

Checkout the configs within the [config](config/) directory. These are the specific configuration files used to configure the systems.

## Things which are currently not configurable

- Root password: Abc1234\_
- OS disk: 20GB (additional 10GB for K3s node)
- CPU/Memory: 2/2048MB
- Template names: debian-10, debian-11, ubuntu-20.04, alpine, debian-k3s-node
- VM IDs:
  - Debian 10/11: 901
  - Ubuntu 20.04: 902
  - Debian 11 k3s node: 903
  - Alpine: 904

## Example

```bash
docker run --rm -ti -w /p -v $PWD:/p -p 12111:12111 --entrypoint /bin/ash hashicorp/packer:light

apk update && apk add ansible sshpass
```

```bash
packer build \
    -var 'proxmox_server=...'               \
    -var 'proxmox_username=...'             \
    -var 'proxmox_password=...'             \
    -var 'proxmox_node=...'                 \
    -var 'proxmox_storage_pool=...'         \
    -var 'proxmox_storage_pool_type=...'    \
    -var 'proxmox_storage_format=...'       \
    -var 'proxmox_iso_file=...'             \
    -var 'http_ip=192.168.2.100'            \
    debian_11.json
```

## Contribute

If you think more stuff should be configurable, feel free to contribute :slightly_smiling_face:
