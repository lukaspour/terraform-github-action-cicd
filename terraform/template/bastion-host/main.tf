data "aws_ami" "bastion_ami" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*",
    ]
  }

  owners = ["099720109477"] # Canonical
}

# this SG should allow custom rules for users
# those rules should be applied by hand in console later on
resource "aws_security_group" "allow_custom_sg" {
  name        = "Custom rules for developers to access bastion"
  description = "Allow custom rules"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "bastion" {
  source = "../../modules/tf_aws_bastion_s3_keys"

  name                 = "${var.global_name}-bastion"
  ami                  = data.aws_ami.bastion_ami.image_id
  instance_type        = "t2.micro"
  region               = var.aws_region
  iam_instance_profile = aws_iam_instance_profile.bastion_readonly.id

  allowed_cidr = [
    "212.45.173.104/29",
    "89.9.250.0/24",
    "195.159.167.140/31",
    "52.48.227.119/32",
    "176.11.189.70/32",
    "89.9.247.0/24",
    "193.179.215.98/31",
  ]

  allowed_ipv6_cidr  = []
  security_group_ids = aws_security_group.allow_custom_sg.id

  vpc_id                      = var.vpc_id
  subnet_ids                  = var.public_subnets
  s3_bucket_name              = var.s3_bucket_ssh_public_keys
  ssh_user                    = "ubuntu"
  keys_update_frequency       = "5,20,35,50 * * * *"
  additional_user_data_script = data.template_file.bastion.rendered
  eip                         = aws_eip.bastion.public_ip
  apply_changes_immediately   = var.apply_changes_immediately
}

data "template_file" "bastion" {
  template = file("${path.module}/user_data/bastion.sh")

  vars = {
    bucket_secrets                     = var.bucket_secrets
    custom_additional_user_data_script = file(coalesce("${var.custom_additional_user_data_script}", "${path.module}/user_data/default_addition.sh"))
  }
}

resource "aws_eip" "bastion" {
  vpc = true
}

data "aws_route53_zone" "this" {
  name         = var.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "bastion" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "bastion.${data.aws_route53_zone.this.name}"
  type    = "A"
  ttl     = "3600"

  records = [
    aws_eip.bastion.public_ip,
  ]
}
