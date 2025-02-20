resource "proxmox_vm_qemu" "ksnode1" {
    name = "ksnode1"
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
    ipconfig0 = "ip=192.168.1.41/24,gw=192.168.1.254"
    nameserver = "192.168.1.173"
    searchdomain = "arnho.org"
}

resource "proxmox_vm_qemu" "ksnode2" {
    name = "ksnode2"
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
    ipconfig0 = "ip=192.168.1.42/24,gw=192.168.1.254"
    nameserver = "192.168.1.173"
    searchdomain = "arnho.org"
}

resource "proxmox_vm_qemu" "ksmaster" {
    name = "ksMaster"
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
    ipconfig0 = "ip=192.168.1.40/24,gw=192.168.1.254"
    nameserver = "192.168.1.173"
    searchdomain = "arnho.org"
}