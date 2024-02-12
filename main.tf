module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

module "security_group" {
  source                    = "./security-groups"
  webserver_ec2_sg_name = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  vpc_id                    = module.networking.webserver_vpc_id
  #webserver_ec2_sg          = "Allow port 443 for webserver"
}

module "tooplate-webserver" {
  source                             = "./tooplate-webserver"
  ami_id                             = var.ec2_ami_id
  instance_type                      = "t2.medium"
  tag_name                           = "Web:Ubuntu Linux EC2"
  public_key                         = var.public_key
  subnet_id                          = tolist(module.networking.webserver_public_subnets)[0]
  sg_for_webserver                   = [module.security_group.sg_webserver_ec2_sg_ssh_http_id]
  enable_public_ip_address           = true
  user_data_install_apacha2_tooplate = templatefile("./tooplate-apache2-script/tooplate-apache2-installer.sh", {})
}

module "lb_target_group" {
  source                   = "./load-balancer-target-group"
  lb_target_group_name     = "webserver-lb-target-group"
  lb_target_group_port     = 80
  lb_target_group_protocol = "HTTP"
  vpc_id                   = module.networking.webserver_vpc_id
  ec2_instance_id          = module.tooplate-webserver.webserver_instance_id
}

module "alb" {
  source                          = "./load-balancer"
  lb_name                         = "webserver-alb"
  is_external                     = false
  lb_type                         = "application"
  sg_enable_webserver_ssh_https   = module.security_group.sg_webserver_ec2_sg_ssh_http_id
  subnet_ids                      = tolist(module.networking.webserver_public_subnets)
  tag_name                        = "webserver-alb"
  lb_target_group_arn             = module.lb_target_group.webserver_lb_target_group_arn
  ec2_instance_id                 = module.tooplate-webserver.webserver_instance_id
  lb_listner_port                 = 80
  lb_listner_protocol             = "HTTP"
  lb_listner_default_action       = "forward"
  lb_https_listner_port           = 443
  lb_https_listner_protocol       = "HTTPS"
  webserver_acm_arn               = module.aws_ceritification_manager.webserver_acm_arn
  lb_target_group_attachment_port = 80
}

module "hosted_zone" {
  source          = "./hosted-zone"
  domain_name     = var.domain_name
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}

module "aws_ceritification_manager" {
  source         = "./certificate-manager"
  domain_name    = var.domain_name
  hosted_zone_id = module.hosted_zone.hosted_zone_id
}