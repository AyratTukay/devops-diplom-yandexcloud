data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "master" {
  name        = "master"
  platform_id = "standard-v1"
  allow_stopping_for_update = true
  resources {
    cores         = 4
    memory        = 2
    core_fraction = 20
   }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    serial-port-enable = "1"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }
  scheduling_policy {
    preemptible = false
  }
}

resource "yandex_compute_instance" "node" {
  name        = "node-${count.index + 1}"
  count = 2
  platform_id = "standard-v2"
  zone = element(var.node_zones, count.index)
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
   }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    serial-port-enable = "1"
  }

  network_interface {
    subnet_id = element([yandex_vpc_subnet.subnet_d.id, yandex_vpc_subnet.subnet_e.id], count.index)
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
}
