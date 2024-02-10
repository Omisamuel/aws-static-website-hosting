variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_for_webserver" {}
variable "enable_public_ip_address" {}
variable "user_data_install_apacha2_tooplate" {}

output "ssh_connection_for_ec2" {
  value = format("%s%s", "ssh -i /home/ubuntu/keys/aws_ec2_webserver_key ubuntu@", aws_instance.webserver_ec2_instance.public_ip)
}

output "webserver_instance_id" {
  value = aws_instance.webserver_ec2_instance.id
}

/* output "webserver_instance_public_id" {
  value = aws_instance.webserver_ec2_instance.public_ip
} */

resource "aws_instance" "webserver_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "aws_ec2_webserver_key"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_for_webserver
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_apacha2_tooplate

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "webserver_ec2_public_key" {
  key_name   = "aws_ec2_webserver_key"
  public_key = var.public_key
}