# Variable

variable "lb_name" {
    type    = string
  default = "webserver-alb"
}
variable "lb_type" {}
variable "is_external" { default = false }
variable "sg_enable_webserver_ssh_https" {}
variable "subnet_ids" {}
variable "tag_name" {}
variable "lb_target_group_arn" {}
variable "ec2_instance_id" {}
variable "lb_listner_port" {}
variable "lb_listner_protocol" {}
variable "lb_listner_default_action" {}
variable "lb_https_listner_port" {}
variable "lb_https_listner_protocol" {}
variable "webserver_acm_arn" {}
variable "lb_target_group_attachment_port" {}

# Output

output "aws_lb_dns_name" {
  value = aws_lb.webserver_lb.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.webserver_lb.zone_id
}

# Load Balancer

resource "aws_lb" "webserver_lb" {
  name               = var.lb_name
  internal           = var.is_external
  load_balancer_type = var.lb_type
  security_groups    = [var.sg_enable_webserver_ssh_https]
  subnets            = var.subnet_ids # Replace with your subnet IDs

  enable_deletion_protection = false

  tags = {
    Name = "webserver-lb"
  }
}

# Load Balancer Target Group Attachment

resource "aws_lb_target_group_attachment" "webserver_lb_target_group_attachment" {
  target_group_arn = var.lb_target_group_arn
  target_id        = var.ec2_instance_id # Replace with your EC2 instance reference
  port             = var.lb_target_group_attachment_port
}

resource "aws_lb_listener" "webserver_lb_listner" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port              = var.lb_listner_port
  protocol          = var.lb_listner_protocol

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}

# https listner on port 443
resource "aws_lb_listener" "webserver_lb_https_listner" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port              = var.lb_https_listner_port
  protocol          = var.lb_https_listner_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.webserver_acm_arn

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}