terraform {
  required_version = ">= 0.14"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.46.0"
    }
  }
}

provider "openstack" {
  // required if auth_url is not specified) An entry in a clouds.yaml file. See the openstacksdk(https://docs.openstack.org/openstacksdk/latest/user/config/configuration.html#config-files) documentation for more information about clouds.yaml files. If omitted, the OS_CLOUD environment variable is used.
  cloud = "shiftstack"
}
