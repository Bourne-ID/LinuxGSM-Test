//output "cluster_" {
//  value = "${rancher2_cluster.primary_cluster.}"
//  sensitive = true
//}
//

output "cluster_registration" {
  value = "${rancher2_cluster.primary_cluster.cluster_registration_token.0.node_command}" #todo: Insecure...
}