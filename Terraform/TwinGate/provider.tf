terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    twingate = {
      source  = "Twingate/twingate"
      version = "~> 3.0.11"
    }
  }
}

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
