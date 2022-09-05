variable "name" {
  type        = string
  description = "Module name."
}

variable "cluster_domain" {
  type        = string
  description = "The identifier for the cluster."
}

variable "network_list" {
  type = list(string)
}

variable "cluster_id" {
  type        = string
  description = "The identifier for the cluster."
}
variable "region" {
  type        = string
  description = "Region name."
}

variable "base_domain" {
  type = string
}
variable "keypair" {
  type = string
}
variable "flavor_name" {
  type = string
}

variable "root_volume_size" {
  type        = number
  description = "The size of the volume in gigabytes for the root block device."
}
