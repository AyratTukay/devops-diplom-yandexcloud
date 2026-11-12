terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.243"
    }
  }
  required_version = ">=1.5.0"


backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "bucket-terraform"
    region = "ru-central1"
    key    = "infra/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}


provider "yandex" {
  service_account_key_file = "${path.module}/sa-key.json"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone = var.zone
}
