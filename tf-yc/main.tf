terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}

variable "yc_id" {
  type = string
}

variable "yc_cloud_id" {
  type = string
}

variable "yc_folder_id" {
  type = string
}

variable "yc_token" {
  type = string
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

resource "yandex_compute_instance" "k8s-vm" {
  name = "CICD K8s VM"

  boot_disk {
    initialize_params {
      image_id="fd8vdg9p6tlb004shc1t"
      size = var.disk_space
    }
  }

  resources {
    cores = var.cpu_cores
    memory = var.ram * 1024
  }

  metadata = {
    ssh-keys = "${file(var.ssh_pub_key_dir)}"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "k8s-vm_ext_ip_add" {
  value = yandex_compute_instance.k8s-vm.network_interface.0.nat_ip_address
}
