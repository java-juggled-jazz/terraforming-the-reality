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

variable "disk_space" {
  type = number
}

variable "cpu_cores" {
  type = number
}

variable "ram" {
  type = number
}

data "twc_os" "os" {
  name = "almalinux"
  version = "9.0"
}

resource "twc_server" "k8s-vm" {
  name = "CICD K8s VM"
  os_id = data.twc_os.os.id

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk = var.disk_space * 1024
    cpu = var.cpu_cores
    ram = var.ram * 1024
  }
}
