
# -------- VLAN10 (MGMT) --------
variable "records_a_mgmt" {
  description = "A records pour le VLAN MGMT (10.10.10.0/24)"
  type        = map(string)
  default     = {
    "opnsense.arnho.fr" = "10.10.10.1"
    "eggman.arnho.fr"   = "10.10.10.14"  # hôte Proxmox (node)
    "proxmox-eggman.arnho.fr"  = "10.10.10.14"  # UI Proxmox
    "truenas.arnho.fr"  = "10.10.10.20"  # VM TrueNAS (à créer)
    "idrac-eggman.arnho.fr" = "10.10.10.15"
    "pve.arnho.fr"             = "10.10.10.11"
    "proxmox-pve.arnho.fr"     = "10.10.10.11"
    "megatron.arnho.fr"        = "10.10.10.12"
    "proxmox-megatron.arnho.fr"= "10.10.10.12"
    "sherka.arnho.fr"          = "10.10.10.13"
    "proxmox-sherka.arnho.fr"  = "10.10.10.13"
    }
}

# -------- VLAN20 (LAN) --------
variable "records_a_lan" {
  description = "A records pour le VLAN LAN (10.20.20.0/24)"
  type        = map(string)
  default     = {
    "pihole.arnho.fr" = "10.20.20.53"
    # "ugame.arnho.fr" = "10.20.20.X"  # décommente et renseigne si tu veux publier UGame
  }
}

# -------- VLAN30 (DMZ) --------
variable "records_a_dmz" {
  description = "A records pour le VLAN DMZ (10.30.30.0/24)"
  type        = map(string)
  default     = {
    "twingate.arnho.fr" = "10.30.30.10"
  }
}

# -------- VLAN40 (IoT) --------
variable "records_a_dmz" {
  description = "A records pour le VLAN IoT (10.40.40.0/24)"
  type        = map(string)
  default     = {

  }
}

# -------- VLAN50 (K8s) --------
variable "records_a_k8s" {
  description = "A records pour le VLAN K8s (10.50.50.0/24)"
  type        = map(string)
  default     = {
    # Exemple si tu fixes tes IPs K8s :
    "ksmaster.arnho.fr" = "10.50.50.10"
    "ksnode1.arnho.fr"  = "10.50.50.11"
    "ksnode2.arnho.fr"  = "10.50.50.12"
  }
}

# -------- CNAME (alias -> cible) --------
variable "records_cname" {
  description = "Alias CNAME"
  type        = map(string)
  default     = {
    "proxmox.arnho.fr" = "proxmox-eggman.arnho.fr"
    # "pve-ui.arnho.fr"      = "proxmox-pve.arnho.fr"
    # "megatron-ui.arnho.fr" = "proxmox-megatron.arnho.fr"
    # "sherka-ui.arnho.fr"   = "proxmox-sherka.arnho.fr"
    "nas.arnho.fr"  = "truenas.arnho.fr"
    "dns.arnho.fr"  = "pihole.arnho.fr"
    "opn.arnho.fr"  = "opnsense.arnho.fr"
    "tg.arnho.fr"   = "twingate.arnho.fr"
  }
}
