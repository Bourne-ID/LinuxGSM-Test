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