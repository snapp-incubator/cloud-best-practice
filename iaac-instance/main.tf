module "instances" {
  source           = "./instances"
  count            = var.instance_count
  name             = "instance-${count.index}"
  cluster_id       = var.cluster_id
  cluster_domain   = local.cluster_domain
  flavor_name      = var.openstack_instance_flavor_name
  root_volume_size = var.openstack_instance_root_volume_size

  keypair      = var.keypair
  base_domain  = var.base_domain
  region       = var.region
  network_list = var.network_list
}