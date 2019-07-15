#!/usr/bin/env bash
terraform apply -target linode_instance.controller
terraform apply -target module.rancher_bootstrap
#terraform apply -target module.cluster_setup
#terraform apply