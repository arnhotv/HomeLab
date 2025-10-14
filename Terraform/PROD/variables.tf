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
    "pve.arnho.fr"             = "10.20.20.11"
    "proxmox-pve.arnho.fr"     = "10.20.20.11"
    "megatron.arnho.fr"        = "10.20.20.12"
    "proxmox-megatron.arnho.fr"= "10.20.20.12"
    "sherka.arnho.fr"          = "10.20.20.13"
    "proxmox-sherka.arnho.fr"  = "10.20.20.13"
    }
}

# -------- VLAN20 (LAN) --------
variable "records_a_lan" {
  description = "A records pour le VLAN LAN (10.20.20.0/24)"
  type        = map(string)
  default     = {
    "pihole.arnho.fr" = "10.20.20.53"
    "ugame.arnho.fr" = "10.20.20.60"
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
variable "records_a_iot" {
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


# ===== Proxmox / SSH =====
variable "pve_eggnode" {
  description = "Nom du nœud Proxmox où créer les templates/VMs"
  type        = string
  default     = "eggman"
}

variable "pve_pvenode" {
  description = "Nom du nœud Proxmox où créer les templates/VMs"
  type        = string
  default     = "pve"
}

variable "pve_meganode" {
  description = "Nom du nœud Proxmox où créer les templates/VMs"
  type        = string
  default     = "megatron"
}

variable "pve_serkanode" {
  description = "Nom du nœud Proxmox où créer les templates/VMs"
  type        = string
  default     = "sherka"
}

variable "pve_egghost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "10.10.10.14"
}

variable "pve_pvehost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "10.20.20.11"
}

variable "pve_megahost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "10.20.20.12"
}

variable "pve_sherkahost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "10.20.20.13"
}

variable "pve_ssh_user" {
  description = "Utilisateur SSH pour le nœud (root conseillé)"
  type        = string
  default     = "root"
}

variable "pve_ssh_private_key" {
  description = "Chemin de la clé privée SSH pour le nœud"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  description = "Clé publique à injecter dans les VMs (Cloud-Init)"
  type        = string
}

variable "pve_storage" {
  description = "Datastore Proxmox pour les disques (ex: local-lvm)"
  type        = string
  default     = "local-lvm"
}

variable "pve_bridge" {
  description = "Bridge réseau Proxmox (ex: vmbr0)"
  type        = string
  default     = "vmbr0"
}