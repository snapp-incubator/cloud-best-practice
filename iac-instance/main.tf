module "instances" {
  source           = "./instances"
  count            = var.instance_count
  name             = "instance-${count.index}"
  flavor_name      = var.openstack_instance_flavor_name
  root_volume_size = var.openstack_instance_root_volume_size

  keypair      = var.keypair
  network_list = var.network_list
}
