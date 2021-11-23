variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}

data "hcloud_ssh_key" "ipad_ssh_key" {
  name = "my-ssh-key"
}

resource "hcloud_server" "testnode1" {
  name        = "testnode1"
  image       = "ubuntu-18.04"
  server_type = "cx21"
  ssh_keys    = ["${data.hcloud_ssh_key.ipad_ssh_key.name}"]
}

output "public_ip4" {
  value = "${hcloud_server.testnode1.ipv4_address}"
}