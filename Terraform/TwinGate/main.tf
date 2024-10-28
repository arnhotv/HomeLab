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