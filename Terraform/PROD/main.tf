########################### CLONES D'EXEMPLE ###########################

# VM de test en VLAN20 (LAN) avec IP statique
# resource "proxmox_vm_qemu" "U_game" {
#     name = "U_game"
#     vmid = "401"
#     target_node = var.pve_pvenode
#     agent = 1
#     clone = "tpl-ubuntu-24.04"
#     memory = 16384
#     tags = "game"

#     cpu {
#       sockets = 1
#       cores = 4
#     }

#     boot = "order=scsi0"

#     disks {
#       scsi {
#         scsi0 {
#           disk {
#             storage = "local-lvm"
#             size = 32
#           }
#         }
#       }
#     }

#     network {
#         id = 0
#         bridge = "vmbr0"
#         model = "virtio"
#         tag = 20
#     }

#     os_type = "cloud-init"
#     sshkeys   = var.ssh_public_key
#     ipconfig0 = "ip=10.20.20.60/24,gw=10.20.20.1"
#     nameserver = "10.20.20.53"
#     searchdomain = "arnho.fr"
# }

########################### VM PROXMOX ###########################

# resource "proxmox_vm_qemu" "Ugame" {
#     name = "Ugame"
#     vmid = "100"
#     target_node = var.pve_pvenode
#     agent = 1
#     memory = 16384
#     tags = "Ubuntu,Game,LAN"
#     onboot = true
#     skip_ipv6 = true

#     cpu {
#       sockets = 1
#       cores = 4
#     }

#     boot = "order=scsi0;ide2"

#     disks {      
#       ide {
#         ide2 {
#           cdrom {
#             iso = "ubuntu-25.10-live-server-amd64.iso"
#           }
#         }
#       }      
#       scsi {
#         scsi0 {
#           disk {
#             storage = "local-lvm"
#             size = 500
#           }
#         }
#       }
#     }

#     network {
#         id = 0
#         bridge = "vmbr0"
#         model = "virtio"
#         tag = 0
#     }

#     os_type = "cloud-init"
#     sshkeys   = var.ssh_public_key
#     ipconfig0 = "ip=10.20.20.60/24,gw=10.20.20.1"
#     nameserver = "10.20.20.53"
#     searchdomain = "arnho.fr"
# }

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
resource "twingate_resource" "Pve_ui" {
  name              = "Pve-UI"
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
resource "twingate_resource" "Pve_ssh" {
  name              = "Pve-SSH"
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
resource "twingate_resource" "Megatron_ui" {
  name              = "Megatron-UI"
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
resource "twingate_resource" "Megatron_ssh" {
  name              = "Megatron-SSH"
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
resource "twingate_resource" "Sherka_ui" {
  name              = "Sherka-UI"
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
resource "twingate_resource" "Sherka_ssh" {
  name              = "Sherka-SSH"
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