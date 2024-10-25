terraform {
  required_providers {
    pihole = {
      source = "ryanwholey/pihole"
    }
  }
}

variable "pihole_api_token" {
    type = string
    sensitive = true
}

provider "pihole" {
  url = "http://pihole.arnho.org" # PIHOLE_URL

  # Requires Pi-hole Web Interface >= 5.11.0
  api_token = var.pihole_api_token # PIHOLE_API_TOKEN
}
