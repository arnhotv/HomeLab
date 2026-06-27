# -------- VLAN10 (MGMT) --------
variable "records_a_mgmt" {
  description = "A records pour le VLAN MGMT"
  type        = map(string)
}

# -------- VLAN20 (LAN) --------
variable "records_a_lan" {
  description = "A records pour le VLAN LAN"
  type        = map(string)
}

# -------- VLAN30 (DMZ) --------
variable "records_a_dmz" {
  description = "A records pour le VLAN DMZ"
  type        = map(string)
}

# -------- VLAN40 (IoT) --------
variable "records_a_iot" {
  description = "A records pour le VLAN IoT"
  type        = map(string)
  default     = {}
}

# -------- VLAN50 (K8s) --------
variable "records_a_k8s" {
  description = "A records pour le VLAN K8s"
  type        = map(string)
  default     = {}
}

# -------- CNAME (alias -> cible) --------
variable "records_cname" {
  description = "Alias CNAME"
  type        = map(string)
  default     = {
    "portainer.arnho-lab.fr" = "docker.arnho-lab.fr"
    "it-tools.arnho-lab.fr"  = "docker.arnho-lab.fr"
    "npm.arnho-lab.fr"       = "docker.arnho-lab.fr"
  }
}

# ===== Proxmox / SSH =====
variable "pve_stalkernode" {
  description = "Nom du nœud Proxmox stalker"
  type        = string
  default     = "stalker"
}

variable "pve_monolithnode" {
  description = "Nom du nœud Proxmox monolith"
  type        = string
  default     = "monolith"
}

variable "pve_sparknode" {
  description = "Nom du nœud Proxmox spark"
  type        = string
  default     = "spark"
}

variable "pve_stalkerhost" {
  description = "Adresse IP du nœud stalker"
  type        = string
}

variable "pve_monolithhost" {
  description = "Adresse IP du nœud monolith"
  type        = string
}

variable "pve_sparkhost" {
  description = "Adresse IP du nœud spark"
  type        = string
}

variable "pve_ssh_user" {
  description = "Utilisateur SSH pour le nœud Proxmox"
  type        = string
  default     = "root"
}

variable "pve_ssh_private_key" {
  description = "Chemin de la clé privée SSH"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
  description = "Clé publique à injecter dans les VMs (Cloud-Init)"
  type        = string
}

variable "pve_storage" {
  description = "Datastore Proxmox pour les disques"
  type        = string
  default     = "local-lvm"
}

variable "pve_bridge" {
  description = "Bridge réseau Proxmox"
  type        = string
  default     = "vmbr0"
}

variable "Dockerusername" {
  description = "Utilisateur cloud-init pour les VMs"
  type        = string
}

variable "Dockerpassword" {
  description = "Mot de passe cloud-init pour les VMs"
  type        = string
  sensitive   = true
}

# ===== Twingate =====
variable "twingate_policy_name" {
  description = "Nom de la politique de sécurité Twingate"
  type        = string
}

variable "twingate_group_id_everyone" {
  description = "ID du groupe Twingate Everyone"
  type        = string
}

variable "twingate_group_id_gameadmin" {
  description = "ID du groupe Twingate GameAdmin"
  type        = string
}

variable "twingate_group_id_mgmt" {
  description = "ID du groupe Twingate Mgmt"
  type        = string
}

variable "twingate_group_id_lan" {
  description = "ID du groupe Twingate Lan"
  type        = string
}

variable "twingate_group_id_dmz" {
  description = "ID du groupe Twingate DMZ"
  type        = string
}

variable "twingate_group_id_iot" {
  description = "ID du groupe Twingate IoT"
  type        = string
}

variable "twingate_group_id_k8s" {
  description = "ID du groupe Twingate K8s"
  type        = string
}

# ===== Adresses IP =====
variable "ip_microtik" {
  description = "IP du MicroTik SFP"
  type        = string
}

variable "ip_tplink" {
  description = "IP du TP-Link"
  type        = string
}

variable "ip_idrac" {
  description = "IP de l'iDRAC"
  type        = string
}

variable "ip_truenas" {
  description = "IP de TrueNAS"
  type        = string
}

variable "ip_pihole" {
  description = "IP de Pi-hole"
  type        = string
}

variable "ip_docker" {
  description = "IP du serveur Docker"
  type        = string
}

variable "ip_amp" {
  description = "IP du serveur AMP/jeux"
  type        = string
}

variable "ip_win1" {
  description = "IP du serveur Windows 1"
  type        = string
}

variable "ip_gateway" {
  description = "IP de la gateway (Freebox)"
  type        = string
}

# ===== Ports Twingate (list(string)) =====
variable "twingate_ports_ssh" {
  description = "Port SSH"
  type        = list(string)
}

variable "twingate_ports_proxmox" {
  description = "Port UI Proxmox"
  type        = list(string)
}

variable "twingate_ports_web" {
  description = "Ports web HTTP+HTTPS"
  type        = list(string)
}

variable "twingate_ports_https" {
  description = "Port HTTPS seul"
  type        = list(string)
}

# ===== Ports Freebox (number) =====
variable "port_https" {
  description = "Port HTTPS"
  type        = number
}

variable "port_avorion_game" {
  description = "Port principal jeu Avorion"
  type        = number
}

variable "port_avorion_query" {
  description = "Port query Steam Avorion"
  type        = number
}

variable "port_avorion_rcon" {
  description = "Port RCON Avorion"
  type        = number
}

variable "port_avorion_steam_start" {
  description = "Début plage ports Steam Avorion"
  type        = number
}

variable "port_avorion_steam_end" {
  description = "Fin plage ports Steam Avorion"
  type        = number
}

variable "port_dcs_game" {
  description = "Port jeu DCS"
  type        = number
}

variable "port_dcs_remote" {
  description = "Port interface web DCS"
  type        = number
}

variable "port_minecraft" {
  description = "Port Minecraft"
  type        = number
}
