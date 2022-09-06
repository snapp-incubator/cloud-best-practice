data "openstack_networking_network_v2" "private_network" {
  name = "private"
}
data "openstack_networking_subnet_v2" "private_subnet" {
  name = "private"
}
resource "openstack_networking_port_v2" "private" {
  name                  = "${var.name}-private"
  admin_state_up        = "true"
  network_id            = data.openstack_networking_network_v2.private_network.id
  port_security_enabled = false
  
}
