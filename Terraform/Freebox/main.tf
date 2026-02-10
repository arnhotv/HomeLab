resource "freebox_port_forwarding" "VintageStory" {
  enabled          = true
  ip_protocol      = "udp"
  target_ip        = "192.168.1.25"
  comment          = "VintageStory"
  source_ip        = "0.0.0.0"
  port_range_start = 42420
  port_range_end   = 42420
}
# resource "freebox_port_forwarding" "TF2" {
#   enabled          = true
#   ip_protocol      = "udp"
#   target_ip        = "192.168.1.25"
#   comment          = "TF2"
#   source_ip        = "0.0.0.0"
#   port_range_start = 27015
#   port_range_end   = 27015
# }
# resource "freebox_port_forwarding" "TF2_RCON" {
#   enabled          = true
#   ip_protocol      = "tcp"
#   target_ip        = "192.168.1.25"
#   comment          = "TF2_RCON"
#   source_ip        = "0.0.0.0"
#   port_range_start = 27015
#   port_range_end   = 27015
# }
resource "freebox_port_forwarding" "MC_Vault" {
  enabled          = true
  ip_protocol      = "tcp"
  target_ip        = "192.168.1.25"
  comment          = "MC_Vault"
  source_ip        = "0.0.0.0"
  port_range_start = 25565
  port_range_end   = 25565
  # source_port      = 25565
  # target_port      = 25565
}

# resource "freebox_port_forwarding" "MC_Vault" {
#       hostname         = "OPNsense"
#       port_range_start = 32769
#       port_range_end   = 32769
#       // ...
# }