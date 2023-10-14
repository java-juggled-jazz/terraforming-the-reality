terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 1.4.4"
}

variable "twc_token" {
  type = string
}

provider "twc" {
  token = var.twc_token
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

variable "ssh_pub_key_dir" {
  type = string
}

data "twc_os" "os" {
  name = "almalinux"
  version = "9.0"
}

resource "twc_ssh_key" "k8s-vm-key" {
  name = "K8s CICD VM SSH key"
  body = file(var.ssh_pub_key_dir)
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
