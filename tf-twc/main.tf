terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 1.4.4"
}

data "twc_configurator" "configurator" {
  location = "ru-1"
  disk_type = "nvme"
}

data "twc_os" "os" {
  name = "almalinux"
  version = "9.0"
}

resource "twc_server" "central-vm" {
  name = "Central Finch"
  os_id = data.twc_os.os.id

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk = 10240
    cpu = 2
    ram = 1024 * 2
  }
}

data "twc_lb_preset" "lb-preset" {
  requests_per_second = "10K"
  price_filter {
    from = 100
    to = 200
  }
}

#resource "twc_lb" "web-lb-1" {
#  name = "Balancing Finch"
#  algo = "roundrobin"
#
#  preset_id = data.twc_lb_preset.lb-preset.id
#
#  is_sticky = false
#  is_use_proxy = false
#  is_ssl = false
#  is_keepalive = false
#
#  health_check {
#    proto = "http"
#
#    port = 80
#
#    inter = 10
#    timeout = 5
#    fall = 3
#    rise = 2
#  }
#
#  ips = [resource.twc_server.web-vm-1.networks.ips.ip, resource.twc_server.web-vm-2.networks.ips.ip]
#}

resource "twc_server" "web-vm-1" {
  name = "First Web Finch"
  os_id = data.twc_os.os.id

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk = 10240
    cpu = 1
    ram = 1024 * 2
  }

  local_network {
#    id = twc_vpс.web-vpc-1.id
  }
}

resource "twc_server" "web-vm-2" {
  name = "Second Web Finch"
  os_id = data.twc_os.os.id

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk = 10240
    cpu = 1
    ram = 1024 * 2
  }

  local_network {
#    id = twc_vpс.web-vpc-1.id
  }
}

#resource "twc_vpc" "web-vpc-1" {
#  name = "Local Finch"
#  subnet_v4 = "192.168.0.0/24"
#  location = "ru-1"
#}
