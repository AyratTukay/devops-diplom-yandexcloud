# Сервисный аккаунт для управления инфраструктурой через Terraform
resource "yandex_iam_service_account" "tf_sa" {
  name        = "terraform-sa"
  description = "Service account for Terraform infrastructure management"
  folder_id   = var.folder_id
}

# Минимально достаточные права
locals {
  sa_roles = [
    "vpc.admin",
    "compute.admin",
    "k8s.admin",
    "k8s.clusters.agent",
    "load-balancer.admin",
    "iam.serviceAccounts.user",
    "storage.admin"
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "tf_sa_roles" {
  for_each  = toset(local.sa_roles)
  folder_id = var.folder_id
  role      = each.key
  member    = "serviceAccount:${yandex_iam_service_account.tf_sa.id}"
}

resource "time_sleep" "wait_for_iam" {
  depends_on      = [yandex_resourcemanager_folder_iam_member.tf_sa_roles]
  create_duration = "15s"
}

# Статический ключ доступа для работы с Object Storage (S3)
resource "yandex_iam_service_account_static_access_key" "tf_sa_static_key" {
  service_account_id = yandex_iam_service_account.tf_sa.id
  description        = "Static access key for Terraform S3 backend"
}

# Авторизованный ключ для самого провайдера Yandex Cloud
resource "yandex_iam_service_account_key" "tf_sa_auth_key" {
  service_account_id = yandex_iam_service_account.tf_sa.id
  description        = "Authorized key for Terraform provider"
}

# S3 бакет для хранения terraform.tfstate
resource "yandex_storage_bucket" "tf_state" {
  access_key = yandex_iam_service_account_static_access_key.tf_sa_static_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tf_sa_static_key.secret_key
  bucket     = var.bucket_name

  # Включаем версионирование для защиты стейт-файла от случайного повреждения
  versioning {
    enabled = true
  }

  # Позволяет удалить бакет при terraform destroy, даже если в нем есть файлы
  force_destroy = true

  depends_on = [time_sleep.wait_for_iam]
}
