variable "lb_target_group_name" {}
variable "lb_target_group_port" {}
variable "lb_target_group_protocol" {}
variable "vpc_id" {}
variable "ec2_instance_id" {}


#output

output "webserver_lb_target_group_arn" {
  value = aws_lb_target_group.webserver_lb_target_group.arn
}


# LB Target Group

resource "aws_lb_target_group" "webserver_lb_target_group" {
  name     = var.lb_target_group_name
  port     = var.lb_target_group_port
  protocol = var.lb_target_group_protocol
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    port = 80
    protocol = "HTTP"
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

# LB Target Group Attachement

resource "aws_lb_target_group_attachment" "webserver_lb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.webserver_lb_target_group.arn
  target_id        = var.ec2_instance_id
  port             = 443
}