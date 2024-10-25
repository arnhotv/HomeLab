resource "proxmox_vm_qemu" "k3s-node-1" {
    name = "k3s-node-1"
    desc = "k3s Worker"
    vmid = "401"
    target_node = "pve"

    agent = 1

    clone = "Ubuntu-ServerTemp"
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 4096
    tags = "k3s"

    boot = "order=scsi0"

    disks {
      scsi {
        scsi0 {
          disk {
            storage = "local-lvm"
            size = 32
          }
        }
      }
    }

    network {
        bridge = "vmbr0"
        model = "virtio"
    }

    os_type = "cloud-init"
    nameserver = "192.168.1.173"
    searchdomain = "arnho.org"
}

resource "proxmox_vm_qemu" "k3s-node-2" {
    name = "k3s-node-2"
    desc = "k3s Worker"
    vmid = "402"
    target_node = "megatron"

    agent = 1

    clone = "Ubuntu-ServerTemp"
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 4096
    tags = "k3s"

    boot = "order=scsi0"

    disks {
      scsi {
        scsi0 {
          disk {
            storage = "local-lvm"
            size = 32
          }
        }
      }
    }

    network {
        bridge = "vmbr0"
        model = "virtio"
    }

    os_type = "cloud-init"
    nameserver = "192.168.1.173"
    searchdomain = "arnho.org"
}

resource "proxmox_vm_qemu" "k3s-Master" {
    name = "k3s-Master"
    desc = "k3s Master"
    vmid = "400"
    target_node = "sherka"

    agent = 1

    clone = "Ubuntu-ServerTemp"
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 4096
    tags = "k3s"

    boot = "order=scsi0"

    disks {
      scsi {
        scsi0 {
          disk {
            storage = "local-lvm"
            size = 32
          }
        }
      }
    }

    network {
        bridge = "vmbr0"
        model = "virtio"
    }

    os_type = "cloud-init"
    nameserver = "192.168.1.173"
    searchdomain = "arnho.org"
}