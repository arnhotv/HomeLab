# -------- VLAN10 (MGMT) --------
variable "records_a_mgmt" {
  description = "A records pour le VLAN MGMT (10.10.10.0/24)"
  type        = map(string)
  default     = {
    "truenas.arnho-lab.fr"              = "192.168.1.203"  # VM TrueNAS (à créer)
    "idrac.arnho-lab.fr"                = "192.168.1.202"
    "stalker.arnho-lab.fr"              = "192.168.1.206"
    "proxmox-stalker.arnho-lab.fr"      = "192.168.1.206"
    "monolith.arnho-lab.fr"             = "192.168.1.205"
    "proxmox-monolith.arnho-lab.fr"     = "192.168.1.205"
    "spark.arnho-lab.fr"                = "192.168.1.207"
    "proxmox-spark.arnho-lab.fr"        = "192.168.1.207"
    "freebox.arnho-lab.fr"              = "192.168.1.254"
    }
}

# -------- VLAN20 (LAN) --------
variable "records_a_lan" {
  description = "A records pour le VLAN LAN (10.20.20.0/24)"
  type        = map(string)
  default     = {
    "pihole.arnho-lab.fr"   = "192.168.1.204"
    "ugame.arnho-lab.fr"    = "192.168.1.208" # VM UGame (à créer)
    # "ugame.arnho-lab.fr" = "10.20.20.X"  # décommente et renseigne si tu veux publier UGame
  }
}

# -------- VLAN30 (DMZ) --------
variable "records_a_dmz" {
  description = "A records pour le VLAN DMZ (10.30.30.0/24)"
  type        = map(string)
  default     = {
    "twingate.arnho-lab.fr" = "192.168.1.209"
    "clouddocker.arnho-lab.fr" = "192.168.1.210"
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
    # "ksmaster.arnho-lab.fr" = "10.50.50.10"
    # "ksnode1.arnho-lab.fr"  = "10.50.50.11"
    # "ksnode2.arnho-lab.fr"  = "10.50.50.12"
  }
}

# -------- CNAME (alias -> cible) --------
variable "records_cname" {
  description = "Alias CNAME"
  type        = map(string)
  default     = {
    "px.arnho-lab.fr" = "proxmox-stalker.arnho-lab.fr"
    # "pve-ui.arnho-lab.fr"      = "proxmox-stalker.arnho-lab.fr"
    # "megatron-ui.arnho-lab.fr" = "proxmox-monolith.arnho-lab.fr"
    # "sherka-ui.arnho-lab.fr"   = "proxmox-spark.arnho-lab.fr"
    "nas.arnho-lab.fr"  = "truenas.arnho-lab.fr"
    "tg.arnho-lab.fr"   = "twingate.arnho-lab.fr"
    "cloud.arnho-lab.fr" = "clouddocker.arnho-lab.fr"
  }
}


# ===== Proxmox / SSH =====
variable "pve_stalkernode" {
  description = "Nom du nœud Proxmox où créer les templates/VMs"
  type        = string
  default     = "stalker"
}

variable "pve_monolithnode" {
  description = "Nom du nœud Proxmox où créer les templates/VMs"
  type        = string
  default     = "monolith"
}

variable "pve_sparknode" {
  description = "Nom du nœud Proxmox où créer les templates/VMs"
  type        = string
  default     = "spark"
}

variable "pve_stalkerhost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "192.168.1.206"
}

variable "pve_monolithhost" {
  description = "Adresse IP/hostname du nœud pour SSH"
  type        = string
  default     = "192.168.1.205"
}

variable "pve_sparkhost" {
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