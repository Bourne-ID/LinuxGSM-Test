provider "rancher2" {
  api_url = "${var.rancher_address}"
  bootstrap = true
  insecure = true //TODO: Bad Practice, must fix.
}

resource "random_string" "password" {
  length = 16
  special = true
  override_special = "/@\" "
}

resource "rancher2_bootstrap" "admin" {
  password = "${random_string.password.result}"
  telemetry = true
}