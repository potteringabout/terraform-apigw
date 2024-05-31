locals {

  network = {
    access = {
      subnets = {
        1 = {
          cidr              = "10.0.0.0/25"
          availability_zone = "${var.region}a"
        }
        2 = {
          cidr              = "10.0.0.128/25"
          availability_zone = "${var.region}b"
        }
      }
    }
    data = {
      subnets = {
        1 = {
          cidr              = "10.0.2.0/25"
          availability_zone = "${var.region}a"
        }
        2 = {
          cidr              = "10.0.2.128/25"
          availability_zone = "${var.region}b"
        }
      }
    }
    app = {
      subnets = {
        1 = {
          cidr              = "10.0.1.0/25"
          availability_zone = "${var.region}a"
        }
        2 = {
          cidr              = "10.0.1.128/25"
          availability_zone = "${var.region}b"
        }
      }
    }


  }


  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  network_subnets = flatten([
    for network_key, network in local.network : [
      for subnet_key, subnet in network.subnets : {
        subnet_name       = "${network_key}${subnet_key}"
        cidr              = subnet.cidr
        availability_zone = subnet.availability_zone
        zone              = network_key
        subnet_number     = subnet_key
      }
    ]
  ])

  access_subnets = {
    for subnet in local.network_subnets : subnet.subnet_name => subnet if subnet.zone == "access"
  }

}
