variable "token" {
  description = "Your API access token"
}

variable "region" {
  description = "The region to deploy Linode instances in"
  default = "eu-west"
}

variable "ssh_key" {
  description = "public key for SSH Authentication"
}

variable "worker_count" {
  description = "The number of worker servers for the Rancher server"
  default = "2"
}