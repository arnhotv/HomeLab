resource "pihole_dns_record" "record" {
  domain = "ksmaster.arnho.org"
  ip     = "191.168.1.40"
}