resource "pihole_dns_record" "ksmaster" {
  domain = "ksmaster.arnho.org"
  ip     = "192.168.1.40"
}

resource "pihole_dns_record" "pihole" {
  domain = "pihole.arnho.org"
  ip = "192.168.1.173"
}

resource "pihole_dns_record" "ugame" {
  domain = "ugame.arnho.org"
  ip = "192.168.1.163"
}