variable "name" {
  type        = string
  description = "Module name."
}

variable "network_list" {
  type = list(string)
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
