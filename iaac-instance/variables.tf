
variable "base_domain" {
  type = string
}
variable "region" {
  type = string
}
variable "cluster_id" {
  type = string
}

variable "network_list" {
  type = list(string)
}

variable "openstack_instance_root_volume_size" {
  type        = number
  default     = null
  description = "The size of the volume in gigabytes for the root block device of instance nodes."
}

variable "openstack_instance_flavor_name" {
  type        = string
  description = "Instance size for the instance node(s)."
}

variable "instance_count" {
  type        = number
  description = "Number of masters"
}

variable "keypair" {
  type = string
}
