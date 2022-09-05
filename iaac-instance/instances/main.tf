data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

data "openstack_networking_port_v2" "port" {
  for_each   = toset(var.network_list)
  name       = "${var.cluster_id}-${var.name}-${each.value}"
  depends_on = [openstack_networking_port_v2.private]
}

data "openstack_images_image_v2" "centos7" {
  name        = "okd4-fcos-33"
  most_recent = true
}

resource "openstack_compute_instance_v2" "instance" {
  name = "${var.cluster_id}-${var.name}"
  key_pair = var.keypair

  flavor_id = data.openstack_compute_flavor_v2.flavor.id


  dynamic "network" {
    for_each = var.network_list
    content {
      port = data.openstack_networking_port_v2.port[network.value].id
    }
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.centos7.id
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = var.root_volume_size
    # volume_type           = "okd4-worker"
  }

}
