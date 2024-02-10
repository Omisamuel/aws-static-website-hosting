terraform {
  backend "s3" {
    bucket = "webserver-remote-state-bucket-20240110"
    key    = "web-project/webserver/terraform.tfstate"
    region = "eu-west-2"
  }
}