# Regroupe proprement les entrées A par VLAN
locals {
  records_a = merge(
    var.records_a_mgmt,
    var.records_a_lan,
    var.records_a_dmz,
    var.records_a_k8s
  )
}

# A records
resource "pihole_dns_record" "a_records" {
  for_each = local.records_a
  domain   = each.key
  ip       = each.value
}

# CNAME records (alias -> cible)
resource "pihole_cname_record" "cname_records" {
  for_each = var.records_cname
  domain   = each.key
  target   = each.value
}
