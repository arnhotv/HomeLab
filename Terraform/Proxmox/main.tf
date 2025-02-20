########################### PROXMOX ###########################
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

########################### PIHOLE ###########################

resource "pihole_dns_record" "ksmaster" {
  domain = "ksmaster.arnho.org"
  ip     = "192.168.1.40"
}

resource "pihole_dns_record" "pihole" {
  domain = "pihole.arnho.org"
  ip = "192.168.1.173"
}

resource "pihole_dns_record" "ugame" {
  domain = "ugame.arnho.org"
  ip = "192.168.1.163"
}

########################### TWINGATE ###########################

data "twingate_remote_network" "arnho" {
  name = "arnho"
}

data "twingate_security_policy" "default" {
  name = "Default Policy"
}

data "twingate_group" "IP_BarBone" {
  id = "R3JvdXA6Mjc0MjU2"
}

data "twingate_group" "Admin" {
  id = "R3JvdXA6MjczMjA0"
}

resource "twingate_resource" "K3S_Master_IP" {
    name              = "K3S_Master_IP"
    address           = "192.168.1.40"
    remote_network_id = data.twingate_remote_network.arnho.id
    security_policy_id = data.twingate_security_policy.default.id

    protocols = {
        allow_icmp = true
        tcp = {
            policy = "ALLOW_ALL"
        }
        udp = {
            policy = "ALLOW_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.IP_BarBone.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}

resource "twingate_resource" "pihole_DNS" {
    name              = "pihole_DNS"
    address           = "pihole.arnho.org"
    remote_network_id = data.twingate_remote_network.arnho.id
    security_policy_id = data.twingate_security_policy.default.id

    protocols = {
        allow_icmp = true
        tcp = {
            policy = "ALLOW_ALL"
        }
        udp = {
            policy = "ALLOW_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Admin.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}

resource "twingate_resource" "UGame_IP" {
    name              = "UGame_IP"
    address           = "192.168.1.163"
    remote_network_id = data.twingate_remote_network.arnho.id
    security_policy_id = data.twingate_security_policy.default.id

    protocols = {
        allow_icmp = true
        tcp = {
            policy = "ALLOW_ALL"
        }
        udp = {
            policy = "ALLOW_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.IP_BarBone.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
