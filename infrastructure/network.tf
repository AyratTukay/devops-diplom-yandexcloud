resource "yandex_vpc_network" "develop" {
  name = "develop-network"
}

resource "yandex_vpc_subnet" "subnet_a" {
  name           = "develop-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "develop-subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.2.0/24"]
}

resource "yandex_vpc_subnet" "subnet_e" {
  name           = "develop-subnet-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.3.0/24"]
}
