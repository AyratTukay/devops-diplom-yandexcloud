variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "bucket_name" {
  type = string
}

variable "sa_id" {
  type        = string
  default     = "ajea0i2239efa01dir59"
  description = "ID сервисного аккаунта из вывода bootstrap"
}

variable "node_zones" {
  type        = list(string)
  default     = ["ru-central1-d", "ru-central1-e"]
}