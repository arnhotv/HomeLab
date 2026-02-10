terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }

    twingate = {
      source  = "Twingate/twingate"
      version = "~> 3.0.11"
    }

    pihole = {
      source  = "lukaspustina/pihole"
      version = "~> 0.3.0"
    }

    freebox = {
      source = "registry.terraform.io/nikolalohinski/freebox"
    }
  }
}

########################### PROXMOX ###########################

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  pm_tls_insecure = true
}


########################### PIHOLE ###########################

variable "pihole_api_token" {
  type      = string
  sensitive = true
}

variable "pihole_password" {
  type      = string
  sensitive = true
  description = "Mot de passe admin Pi-hole"
}

# Pi-hole écoute en HTTPS avec cert auto-signé → insecure_tls = true (à ajuster si besoin)
provider "pihole" {
  url          = "https://192.168.1.204"
  password     = var.pihole_password
  insecure_tls = true
}

########################### TWINGATE ###########################

variable "twingate_remote_network" {
  type      = string
  sensitive = true
}

variable "twingate_api_token" {
  type        = string
  description = "Twingate API"
  sensitive   = true
}

provider "twingate" {
  api_token = var.twingate_api_token
  network   = var.twingate_remote_network
}

########################### FREEBOX ###########################

variable "FREEBOX_ENDPOINT" {
  type = string
}

variable "FREEBOX_VERSION" {
  type = string
}

variable "FREEBOX_APP_ID" {
  type = string
  sensitive = true
}

variable "FREEBOX_TOKEN" {
  type = string
  sensitive = true
}

provider "freebox" {
  endpoint    = var.FREEBOX_ENDPOINT
  api_version = var.FREEBOX_VERSION
  app_id      = var.FREEBOX_APP_ID
  token       = var.FREEBOX_TOKEN
}