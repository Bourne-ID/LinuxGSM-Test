output "rancher_url" {
  value = "${var.rancher_address}"
}

output "rancher_password" {
  value = "${rancher2_bootstrap.admin.password}"
  sensitive = true
}

output "rancher_token" {
  value = "${rancher2_bootstrap.admin.token}"
  sensitive = true
}

