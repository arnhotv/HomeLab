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

# resource "twingate_resource" "K3S_Master_IP" {
#     name              = "K3S_Master_IP"
#     address           = "192.168.1.40"
#     remote_network_id = data.twingate_remote_network.arnho.id
#     security_policy_id = data.twingate_security_policy.default.id

#     protocols = {
#         allow_icmp = true
#         tcp = {
#             policy = "ALLOW_ALL"
#         }
#         udp = {
#             policy = "ALLOW_ALL"
#         }
#     }

#     dynamic "access_group" {
#         for_each = [data.twingate_group.IP_BarBone.id]
#         content {
#             group_id = access_group.value
#             security_policy_id = data.twingate_security_policy.default.id
#         }
#     }

#     is_active = true
# }

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
resource "twingate_resource" "pihole_ssh" {
  name              = "Pi-Hole-SSH"
  address           = "10.20.20.53"
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
