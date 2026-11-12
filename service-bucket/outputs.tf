resource "local_file" "sa_key_file" {
  content = jsonencode({
    id                 = yandex_iam_service_account_key.tf_sa_auth_key.id
    service_account_id = yandex_iam_service_account_key.tf_sa_auth_key.service_account_id
    created_at         = yandex_iam_service_account_key.tf_sa_auth_key.created_at
    key_algorithm      = yandex_iam_service_account_key.tf_sa_auth_key.key_algorithm
    public_key         = yandex_iam_service_account_key.tf_sa_auth_key.public_key
    private_key        = yandex_iam_service_account_key.tf_sa_auth_key.private_key
  })
  filename        = "${path.module}/../infrastructure/sa-key.json"
  file_permission = "0600"
}

resource "local_file" "backend_config" {
  content = <<-EOT
    access_key = "${yandex_iam_service_account_static_access_key.tf_sa_static_key.access_key}"
    secret_key = "${yandex_iam_service_account_static_access_key.tf_sa_static_key.secret_key}"
  EOT
  filename        = "${path.module}/../infrastructure/backend.tfvars"
  file_permission = "0600"
}

output "service_account_id" {
  value = yandex_iam_service_account.tf_sa.id
}
