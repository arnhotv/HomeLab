########################### VM PROXMOX ###########################

resource "proxmox_vm_qemu" "Nextcloud" {
    name = "Nextcloud"
    vmid = "100"
    target_node = var.pve_monolithnode
    boot = "order=scsi0"
    vm_state = "running"
    agent = 1
    memory = 4096
    tags = "nextcloud"
    skip_ipv6 = true
    clone = "TPLRHEL9"
    full_clone = true
    scsihw = "virtio-scsi-single"
    startup_shutdown {
      order = "-1"
      shutdown_timeout = "-1"
      startup_delay = "-1"   
    }
    cpu {
      sockets = 1
      cores = 2
      type = "host"
    }

    disks {           
      scsi {
        scsi0 {
          disk {
            storage = "local-lvm"
            cache = "writeback"
            discard = true
            iothread = "1"
            size = 20
          }
        }
      }
    }

    network {
        id = 0
        bridge = "vmbr0"
        model = "virtio"
        tag = 0
    }
    ipconfig0   = "ip=192.168.1.210/24,gw=192.168.1.254"
    os_type     = "cloud-init"
    nameserver  = "192.168.1.204"
    searchdomain = "arnho-lab.fr"
    sshkeys     = var.ssh_public_key

}
resource "proxmox_vm_qemu" "AMP" {
    name = "AMP"
    vmid = 101
    target_node = var.pve_stalkernode
    agent = 1
    memory = 16384
    tags = "amp,cloud-init"
    boot = "order=scsi0"
    vm_state = "running"
    clone = "ubuntu-cloudinit"
    scsihw = "virtio-scsi-single"
    automatic_reboot = true

    cicustom   = "vendor=local:snippets/qemu-guest-agent.yml"
    ciupgrade = true
    nameserver = "192.168.1.204 192.168.1.254"
    ipconfig0 = "ip=192.168.1.212/24,gw=192.168.1.254"
    skip_ipv6 = true
    ciuser = "root"
    cipassword = "ey$cW5uEJz3D9E@U"
    sshkeys = var.ssh_public_key

    startup_shutdown {
      order = "-1"
      shutdown_timeout = "-1"
      startup_delay = "-1"   
    }
    cpu {
      sockets = 1
      cores = 8
      type = "host"
    }
    serial {
        id = 0
    }
    disks {           
      scsi {
        scsi0 {
          disk {
            storage = "local-lvm"
            discard = true
            iothread = "1"
            size = 32
            emulatessd = true
          }
        }
      }
      ide {
        ide1 {
          cloudinit {
            storage = "local-lvm"
          }
        }
      }
    }
      network {
    id = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
}

########################### PIHOLE ###########################

# Regroupe proprement les entrées A par VLAN
locals {
  records_a = merge(
    var.records_a_mgmt,
    var.records_a_lan,
    var.records_a_dmz,
    var.records_a_k8s
  )
}

# A records
resource "pihole_dns_record" "a_records" {
  for_each = local.records_a
  domain   = each.key
  ip       = each.value
}

# CNAME records (alias -> cible)
resource "pihole_cname_record" "cname_records" {
  for_each = var.records_cname
  domain   = each.key
  target   = each.value
}


########################### TWINGATE ###########################

data "twingate_remote_network" "arnho" {
  name = "arnho"
}

data "twingate_security_policy" "default" {
  name = "Default Policy"
}

data "twingate_group" "Everyone" {
  id = "R3JvdXA6MjUxNDE0"
}

data "twingate_group" "GameAdmin" {
  id = "R3JvdXA6MjczMjA0"
}

data "twingate_group" "Mgmt" {
  id = "R3JvdXA6Mjc0MjU2"
}

data "twingate_group" "Lan" {
  id = "R3JvdXA6NDEzNTM5"
}

data "twingate_group" "DMZ" {
  id = "R3JvdXA6NDEzNTQw"
}

data "twingate_group" "IoT" {
  id = "R3JvdXA6NDEzNTQx"
}

data "twingate_group" "K8s" {
  id = "R3JvdXA6NDEzNTQz"
}

resource "twingate_resource" "MicroTikSFP_ui" {
  name              = "MicroTikSFP_ui"
  address           = "192.168.1.200"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports =["80","443"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "TpLink5_ui" {
  name              = "TP-Link-UI"
  address           = "192.168.1.201"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports =["80","443"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "iDRAC_ui" {
  name              = "iDRAC-UI"
  address           = "192.168.1.202"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports =["80","443"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "Truenas_ui" {
  name              = "Truenas-UI"
  address           = "192.168.1.203"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["80","443"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Lan.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "Truenas_ssh" {
  name              = "Truenas-SSH"
  address           = "192.168.1.203"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["22"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "pihole_ui" {
  name              = "Pi-Hole-UI"
  address           = "192.168.1.204"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports =["443"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Lan.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "pihole_ssh" {
  name              = "Pi-Hole-SSH"
  address           = "192.168.1.204"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports =["22"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "Stalker_ui" {
  name              = "Stalker-UI"
  address           = "192.168.1.206"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["8006"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "Stalker_ssh" {
  name              = "Stalker-SSH"
  address           = "192.168.1.206"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["22"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "Monolith_ui" {
  name              = "Monolith-UI"
  address           = "192.168.1.205"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["8006"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "Monolith_ssh" {
  name              = "Monolith-SSH"
  address           = "192.168.1.205"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["22"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "Spark_ui" {
  name              = "Spark-UI"
  address           = "192.168.1.207"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["8006"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "Spark_ssh" {
  name              = "Spark-SSH"
  address           = "192.168.1.207"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["22"]
        }
        udp = {
            policy = "DENY_ALL"
        }
    }

    dynamic "access_group" {
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}


########################### FREEBOX ###########################

# resource "freebox_port_forwarding" "template" { 
#   enabled          = true
#   ip_protocol      = "udp"
#   target_ip        = "192.168.1.25"
#   comment          = "template"
#   source_ip        = "0.0.0.0"
#   port_range_start = 42420
#   port_range_end   = 42420
# }

########################### K3S ###########################