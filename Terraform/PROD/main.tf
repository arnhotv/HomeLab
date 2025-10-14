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

resource "proxmox_vm_qemu" "Dgame" {
    name = "Dgame"
    vmid = "100"
    target_node = var.pve_pvenode
    agent = 1
    memory = 16384
    tags = "Debian,Game,LAN"
    onboot = true
    skip_ipv6 = true

    cpu {
      sockets = 1
      cores = 4
    }

    boot = "order=scsi0"

    disks {
      scsi {
        scsi0 {
          disk {
            storage = "local-lvm"
            size = 500
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

    os_type = "cloud-init"
    sshkeys   = var.ssh_public_key
    ipconfig0 = "ip=10.20.20.60/24,gw=10.20.20.1"
    nameserver = "10.20.20.53"
    searchdomain = "arnho.fr"
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

resource "twingate_resource" "Eggman_ui" {
  name              = "Eggman-UI"
  address           = "10.10.10.14"
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
resource "twingate_resource" "Eggman_ssh" {
  name              = "Eggman-SSH"
  address           = "10.10.10.14"
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
resource "twingate_resource" "Pve_ui" {
  name              = "Pve-UI"
  address           = "10.20.20.11"
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
  address           = "10.20.20.11"
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
  address           = "10.20.20.12"
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
  address           = "10.20.20.12"
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
  address           = "10.20.20.13"
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
  address           = "10.20.20.13"
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
resource "twingate_resource" "opnsense_ui" {
  name              = "OPNsense-UI"
  address           = "10.10.10.1"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["443"]
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
resource "twingate_resource" "truenas_ui" {
  name              = "TrueNAS-UI"
  address           = "10.10.10.20"
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
        for_each = [data.twingate_group.Mgmt.id]
        content {
            group_id = access_group.value
            security_policy_id = data.twingate_security_policy.default.id
        }
    }
    
    is_active = true
}
resource "twingate_resource" "idrac_eggman" {
  name              = "iDRAC-Eggman"
  address           = "10.10.10.15"
  remote_network_id = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
    protocols = {
        allow_icmp = true
        tcp = {
            policy = "RESTRICTED"
            ports = ["443"]
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
  address           = "10.20.20.53"
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

########################### FREEBOX ###########################

resource "freebox_port_forwarding" "VintageStory" {
  enabled          = true
  ip_protocol      = "udp"
  target_ip        = "192.168.1.25"
  comment          = "VintageStory"
  source_ip        = "0.0.0.0"
  source_port      = 42420
  target_port      = 42420
}
resource "freebox_port_forwarding" "TF2" {
  enabled          = true
  ip_protocol      = "udp"
  target_ip        = "192.168.1.25"
  comment          = "TF2"
  source_ip        = "0.0.0.0"
  source_port      = 27015
  target_port      = 27015
}
resource "freebox_port_forwarding" "TF2_RCON" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = "192.168.1.25"
  comment          = "TF2_RCON"
  source_ip        = "0.0.0.0"
  source_port      = 27015
  target_port      = 27015
}
resource "freebox_port_forwarding" "MC_Vault" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = "192.168.1.25"
  comment          = "MC_Vault"
  source_ip        = "0.0.0.0"
  source_port      = 25565
  target_port      = 25565
}

########################### K3S ###########################