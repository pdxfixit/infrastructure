variable "cf_email" {}
variable "cf_token" {}
variable "do_token" {}

provider "cloudflare" {
  email = "${var.cf_email}"
  token = "${var.cf_token}"
}

provider "digitalocean" {
  token = "${var.do_token}"
}
