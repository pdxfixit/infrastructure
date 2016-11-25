variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "pdxfixit" {
  image = "ubuntu-16-04-x64"
  name = "pdxfixit"
  region = "sfo1"
  size = "512mb"
  backups = "true"
  ssh_keys = ["a3:87:57:8b:09:7c:59:c5:f7:cc:75:77:26:6f:ab:38"]
  user_data = "${file("Setup.sh")}"
}
