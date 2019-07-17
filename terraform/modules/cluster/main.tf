provider "rancher2" {
  api_url = "${var.rancher_address}"
  insecure = true //TODO: Bad Practice, must fix.
  token_key = "${var.token_key}"
}

//resource "random_string" "password" {
//  length = 16
//  special = true
//  override_special = "/@\" "
//}

resource "rancher2_cluster" "primary_cluster" {
  name = "primarycluster"
  description = "Primary Cluster to enrol VMs into"
  rke_config {
    network {
      plugin = "canal"
    }
  }

}