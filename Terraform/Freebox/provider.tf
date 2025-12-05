terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    freebox = {
      source = "registry.terraform.io/nikolalohinski/freebox"
    }
  }
}

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