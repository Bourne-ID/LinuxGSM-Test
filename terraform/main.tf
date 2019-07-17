# Configure the Linode provider
provider "linode" {
  token = "${var.token}"
}

resource "random_string" "password" {
  length = 16
  special = true
  override_special = "/@\" "
}

  resource "linode_instance" "controller" {
  image = "linode/ubuntu16.04lts"
  label = "LinuxGSM_Controller"
  group = "Terraform"
  region = "eu-west"
  type = "g6-standard-6"
  authorized_keys = [ "${var.ssh_key}" ]
  private_ip = true
  root_pass = "${random_string.password.result}"
//  id = "${random_pet.server.keepers.random_pet_trigger}"
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${self.label}",
      "sudo sed -i '1i127.0.0.1\t${self.label}\n' /etc/hosts",
      "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1",
      "sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "docker run -d --name lancache-dns -p 53:53/udp -e USE_GENERIC_CACHE=true -e LANCACHE_IP=${linode_instance.controller.private_ip_address} lancachenet/lancache-dns:latest",
      "docker run -d --restart unless-stopped --name cache-steam -v /tmp/steam/data:/data/cache -v /tmp/steam/logs:/data/logs -p 80:80 lancachenet/monolithic:latest",
      "docker run -d --restart unless-stopped --name sniproxy -p 443:443 steamcache/sniproxy:latest",
      "docker run -d --restart=unless-stopped -p 4433:443 rancher/rancher:v2.2.4"
    ]
    connection {
      password = "${random_string.password.result}"
    }
  }
}

module "rancher_bootstrap" {
  source = "./modules/rancher"
  rancher_address = "https://${linode_instance.controller.ip_address}:4433"
}

module "cluster_setup" {
  source = "./modules/cluster"
  rancher_address = "https://${linode_instance.controller.ip_address}:4433"
  token_key = "${module.rancher_bootstrap.rancher_token}"
}

// Because every autonomonous server should have a name :D
resource "random_pet" "worker_pet_name" {
  count = "${var.worker_count}"
}

resource "random_pet" "rancher_controller" {
  count = "${var.controller_count}"
}

resource "linode_instance" "rancher_controller" {
  count = "${var.controller_count}"
  image = "linode/ubuntu16.04lts"
  label = "${element(random_pet.rancher_controller.*.id, count.index)}"
  group = "Terraform"
  region = "eu-west"
  type = "g6-standard-6"
  authorized_keys = [ "${var.ssh_key}" ]
  private_ip = true
  root_pass = "${random_string.password.result}"
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${element(random_pet.rancher_controller.*.id, count.index)}",
      "sudo sed -i '1i127.0.0.1\t${element(random_pet.rancher_controller.*.id, count.index)}\n' /etc/hosts",
      "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1",
      "sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "echo \"deb https://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main\" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo ${module.cluster_setup.cluster_registration} --etcd --controlplane --worker"
    ]
    connection {
      password = "${random_string.password.result}"
    }
  }
}

resource "linode_instance" "workers" {
  count = "${var.worker_count}"
  image = "linode/ubuntu16.04lts"
  label = "${element(random_pet.worker_pet_name.*.id, count.index)}"
  group = "Terraform"
  region = "eu-west"
  type = "g6-standard-6"
  authorized_keys = [ "${var.ssh_key}" ]
  private_ip = true
  root_pass = "${random_string.password.result}"
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${element(random_pet.worker_pet_name.*.id, count.index)}",
      "sudo sed -i '1i127.0.0.1\t${element(random_pet.worker_pet_name.*.id, count.index)}\n' /etc/hosts",
      "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1",
      "sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "echo \"deb https://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main\" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo ${module.cluster_setup.cluster_registration} --worker"
    ]
    connection {
      password = "${random_string.password.result}"
    }
  }
}

//TODO: Activate when we want extra storage with provisioning to set up and link
//resource "linode_volume" "foobar" {
//  label = "foo-volume"
//  region = "${linode_instance.lgsm_controller.region}"
//  linode_id = "${linode_instance.lgsm_controller.id}"
//  size = 2000
//}

