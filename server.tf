provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "pdxfixit" {
  image = "ubuntu-16-04-x64"
  name = "pdxfixit"
  region = "sfo1"
  size = "512mb"
  backups = "true"
  ssh_keys = ["79:28:df:ec:a6:da:6c:18:11:ab:85:8a:b3:33:c2:1e"]
  user_data = ${file("Setup.sh")}
}
