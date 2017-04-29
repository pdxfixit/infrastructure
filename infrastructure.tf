resource "digitalocean_droplet" "pdxfixit" {
  image = "ubuntu-16-04-x64"
  name = "pdxfixit"
  region = "sfo1"
  size = "512mb"
  backups = "true"
  ssh_keys = ["a3:87:57:8b:09:7c:59:c5:f7:cc:75:77:26:6f:ab:38"]
//  user_data = "${file("Setup.sh")}"
}

resource "digitalocean_floating_ip" "pdxfixit" {
  droplet_id = "${digitalocean_droplet.pdxfixit.id}"
  region     = "${digitalocean_droplet.pdxfixit.region}"
}

resource "cloudflare_record" "direct" {
  domain = "pdxfixit.com"
  name   = "direct"
  value  = "${digitalocean_floating_ip.pdxfixit.ip_address}"
  type   = "A"
  ttl    = 3600
}

resource "cloudflare_record" "www" {
  domain = "pdxfixit.com"
  name   = "www"
  value  = "${digitalocean_floating_ip.pdxfixit.ip_address}"
  type   = "A"
  ttl    = 3600
}
