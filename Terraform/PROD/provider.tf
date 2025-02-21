terraform {

    required_version = ">= 0.13.0"

    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
            version = "3.0.1-rc3"
        }
        
        twingate = {
        source = "Twingate/twingate"
        version = "~> 3.0.11"
        }

        pihole = {
        source = "ryanwholey/pihole"
        }
    }
}

########################### PROXMOX ###########################

variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
    type = string
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
    type = string
    sensitive = true
}

provider "pihole" {
  url = "http://pihole.arnho.org" # PIHOLE_URL

  # Requires Pi-hole Web Interface >= 5.11.0
  api_token = var.pihole_api_token # PIHOLE_API_TOKEN
}

########################### TWINGATE ###########################

variable "twingate_remote_network" {
    type = string
    sensitive = true
}

variable "twingate_api_token" {
    type = string
    description = "Twingate API"
    sensitive = true
}

provider "twingate" {
  api_token = var.twingate_api_token
  network   = var.twingate_remote_network
}