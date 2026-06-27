########################### VM PROXMOX ###########################

resource "proxmox_vm_qemu" "Docker" {
    name = "Docker"
    vmid = "100"
    target_node = var.pve_monolithnode
    boot = "order=scsi0"
    vm_state = "running"
    agent = 1
    memory = 28672
    tags = "docker,terraform,red-hat9"
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
      cores = 10
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
            size = 100
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
    ipconfig0   = "ip=${var.ip_docker}/24,gw=${var.ip_gateway}"
    os_type     = "cloud-init"
    nameserver  = var.ip_pihole
    searchdomain = "arnho-lab.fr"
    sshkeys     = var.ssh_public_key

}
resource "proxmox_vm_qemu" "AMP" {
    name = "AMP"
    vmid = 101
    target_node = var.pve_stalkernode
    agent = 1
    memory = 16384
    tags = "amp,cloud-init,terraform,ubuntu"
    boot = "order=scsi0"
    vm_state = "running"
    clone = "ubuntu-cloudinit"
    scsihw = "virtio-scsi-single"
    automatic_reboot = true

    cicustom   = "vendor=local:snippets/qemu-guest-agent.yml"
    ciupgrade = true
    nameserver = "${var.ip_pihole} ${var.ip_gateway}"
    ipconfig0 = "ip=${var.ip_amp}/24,gw=${var.ip_gateway}"
    searchdomain = "arnho-lab.fr"
    skip_ipv6 = true
    ciuser = var.Dockerusername
    cipassword = var.Dockerpassword
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
            size = 100
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

locals {
  records_a = merge(
    var.records_a_mgmt,
    var.records_a_lan,
    var.records_a_dmz,
    var.records_a_k8s
  )
}

resource "pihole_dns_record" "a_records" {
  for_each = local.records_a
  domain   = each.key
  ip       = each.value
}

resource "pihole_cname_record" "cname_records" {
  for_each = var.records_cname
  domain   = each.key
  target   = each.value
}

########################### TWINGATE ###########################

data "twingate_remote_network" "arnho" {
  name = var.twingate_remote_network
}

data "twingate_security_policy" "default" {
  name = var.twingate_policy_name
}

data "twingate_group" "Everyone" {
  id = var.twingate_group_id_everyone
}

data "twingate_group" "GameAdmin" {
  id = var.twingate_group_id_gameadmin
}

data "twingate_group" "Mgmt" {
  id = var.twingate_group_id_mgmt
}

data "twingate_group" "Lan" {
  id = var.twingate_group_id_lan
}

data "twingate_group" "DMZ" {
  id = var.twingate_group_id_dmz
}

data "twingate_group" "IoT" {
  id = var.twingate_group_id_iot
}

data "twingate_group" "K8s" {
  id = var.twingate_group_id_k8s
}

resource "twingate_resource" "MicroTikSFP_ui" {
  name               = "MicroTikSFP_ui"
  address            = var.ip_microtik
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_web
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "TpLink5_ui" {
  name               = "TP-Link-UI"
  address            = var.ip_tplink
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_web
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "iDRAC_ui" {
  name               = "iDRAC-UI"
  address            = var.ip_idrac
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_web
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "Truenas_ui" {
  name               = "Truenas-UI"
  address            = var.ip_truenas
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_web
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Lan.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "Truenas_ssh" {
  name               = "Truenas-SSH"
  address            = var.ip_truenas
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_ssh
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "pihole_ui" {
  name               = "Pi-Hole-UI"
  address            = var.ip_pihole
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_https
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Lan.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "pihole_ssh" {
  name               = "Pi-Hole-SSH"
  address            = var.ip_pihole
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_ssh
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "Stalker_ui" {
  name               = "Stalker-UI"
  address            = var.pve_stalkerhost
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_proxmox
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "Stalker_ssh" {
  name               = "Stalker-SSH"
  address            = var.pve_stalkerhost
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_ssh
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "Monolith_ui" {
  name               = "Monolith-UI"
  address            = var.pve_monolithhost
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_proxmox
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "Monolith_ssh" {
  name               = "Monolith-SSH"
  address            = var.pve_monolithhost
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_ssh
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "Spark_ui" {
  name               = "Spark-UI"
  address            = var.pve_sparkhost
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_proxmox
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

resource "twingate_resource" "Spark_ssh" {
  name               = "Spark-SSH"
  address            = var.pve_sparkhost
  remote_network_id  = data.twingate_remote_network.arnho.id
  security_policy_id = data.twingate_security_policy.default.id
  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = var.twingate_ports_ssh
    }
    udp = {
      policy = "DENY_ALL"
    }
  }
  dynamic "access_group" {
    for_each = [data.twingate_group.Mgmt.id]
    content {
      group_id           = access_group.value
      security_policy_id = data.twingate_security_policy.default.id
    }
  }
  is_active = true
}

########################### FREEBOX ###########################

resource "freebox_port_forwarding" "docker" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = var.ip_docker
  comment          = "Docker"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_https
  port_range_end   = var.port_https
}

resource "freebox_port_forwarding" "Avoriongame_tcp" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = var.ip_amp
  comment          = "Avorion"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_avorion_game
  port_range_end   = var.port_avorion_game
}

resource "freebox_port_forwarding" "Avoriongame_udp" {
  enabled          = true
  ip_protocol      = "udp"
  target_ip        = var.ip_amp
  comment          = "Avorion"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_avorion_game
  port_range_end   = var.port_avorion_game
}

resource "freebox_port_forwarding" "Avorionquery_udp" {
  enabled          = true
  ip_protocol      = "udp"
  target_ip        = var.ip_amp
  comment          = "Avorion"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_avorion_query
  port_range_end   = var.port_avorion_query
}

resource "freebox_port_forwarding" "AvorionRCON_tcp" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = var.ip_amp
  comment          = "Avorion"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_avorion_rcon
  port_range_end   = var.port_avorion_rcon
}

resource "freebox_port_forwarding" "AvorionSteam_tcp" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = var.ip_amp
  comment          = "Avorion"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_avorion_steam_start
  port_range_end   = var.port_avorion_steam_end
}

resource "freebox_port_forwarding" "AvorionSteam_udp" {
  enabled          = true
  ip_protocol      = "udp"
  target_ip        = var.ip_amp
  comment          = "Avorion"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_avorion_steam_start
  port_range_end   = var.port_avorion_steam_end
}

resource "freebox_port_forwarding" "DCSGame_udp" {
  enabled          = true
  ip_protocol      = "udp"
  target_ip        = var.ip_win1
  comment          = "DCS"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_dcs_game
  port_range_end   = var.port_dcs_game
}

resource "freebox_port_forwarding" "DCSGame_tcp" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = var.ip_win1
  comment          = "DCS"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_dcs_game
  port_range_end   = var.port_dcs_game
}

resource "freebox_port_forwarding" "DCSRemoteWeb_tcp" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = var.ip_win1
  comment          = "DCS Remote"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_dcs_remote
  port_range_end   = var.port_dcs_remote
}

resource "freebox_port_forwarding" "MC_ATM10_tcp" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = var.ip_amp
  comment          = "Minecraft ATM10"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_minecraft
  port_range_end   = var.port_minecraft
}

resource "freebox_port_forwarding" "MC_ATM10_udp" {
  enabled          = true
  ip_protocol      = "udp"
  target_ip        = var.ip_amp
  comment          = "Minecraft ATM10"
  source_ip        = "0.0.0.0"
  port_range_start = var.port_minecraft
  port_range_end   = var.port_minecraft
}

########################### K3S ###########################
