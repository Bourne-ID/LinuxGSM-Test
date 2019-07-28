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

variable "worker_count_a" {
  description = "The number of worker servers for the Rancher server in pool A"
  default = "1"
}

variable "worker_count_b" {
  description = "The number of worker servers for the Rancher server in pool B"
  default = "0"
}

variable "controller_count" {
  description = "The number of controller (and worker) servers for the Rancher server"
  default = "1"
}
