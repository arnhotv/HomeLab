# -------- VLAN10 (MGMT) --------
variable "records_a_mgmt" {
  description = "A records pour le VLAN MGMT (10.10.10.0/24)"
  type        = map(string)
  default     = {
    "truenas.arnho.fr"  = "192.168.1.203"  # VM TrueNAS (à créer)
    "idrac-eggman.arnho.fr" = "192.168.1.202"
    "pve.arnho.fr"             = "192.168.1.205"
    "proxmox-pve.arnho.fr"     = "192.168.1.205"
    "megatron.arnho.fr"        = "192.168.1.206"
    "proxmox-megatron.arnho.fr"= "192.168.1.206"
    "sherka.arnho.fr"          = "192.168.1.207"
    "proxmox-sherka.arnho.fr"  = "192.168.1.207"
    }
}

# -------- VLAN20 (LAN) --------
variable "records_a_lan" {
  description = "A records pour le VLAN LAN (10.20.20.0/24)"
  type        = map(string)
  default     = {
    "pihole.arnho.fr" = "192.168.1.204"
    "ugame.arnho.fr" = "192.168.1.208" # VM UGame (à créer)
    # "ugame.arnho.fr" = "10.20.20.X"  # décommente et renseigne si tu veux publier UGame
  }
}

# -------- VLAN30 (DMZ) --------
variable "records_a_dmz" {
  description = "A records pour le VLAN DMZ (10.30.30.0/24)"
  type        = map(string)
  default     = {
    "twingate.arnho.fr" = "192.168.1.209"
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
    # "ksmaster.arnho.fr" = "10.50.50.10"
    # "ksnode1.arnho.fr"  = "10.50.50.11"
    # "ksnode2.arnho.fr"  = "10.50.50.12"
  }
}

# -------- CNAME (alias -> cible) --------
variable "records_cname" {
  description = "Alias CNAME"
  type        = map(string)
  default     = {
    "proxmox.arnho.fr" = "proxmox-pve.arnho.fr"
    # "pve-ui.arnho.fr"      = "proxmox-pve.arnho.fr"
    # "megatron-ui.arnho.fr" = "proxmox-megatron.arnho.fr"
    # "sherka-ui.arnho.fr"   = "proxmox-sherka.arnho.fr"
    "nas.arnho.fr"  = "truenas.arnho.fr"
    "dns.arnho.fr"  = "pihole.arnho.fr"
    "tg.arnho.fr"   = "twingate.arnho.fr"
  }
}


# ===== Proxmox / SSH =====
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

variable "pve_pvehost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "192.168.1.205"
}

variable "pve_megahost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "192.168.1.206"
}

variable "pve_sherkahost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "192.168.1.207"
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