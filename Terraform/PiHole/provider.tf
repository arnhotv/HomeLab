terraform {
  required_providers {
    pihole = {
      source  = "lukaspustina/pihole"
      version = "~> 0.3.0"
    }
  }
}

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
  url          = "https://10.20.20.53"
  password     = var.pihole_password
  insecure_tls = true
}
