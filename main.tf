terraform {
  cloud {
    organization = "dragon-ws"

    workspaces {
      name = "saa-c03"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  user_data = <<-EOF
                #!/bin/bash
                # Use this for your user data (script from top to bottom)
                # install httpd (Linux 2 version)
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
                EOF

  s3_policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })

  vpc_log_policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "logs:CreateLogGroup",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "logs:CreateLogStream",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "logs:PutLogEvents",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "logs:DescribeLogStreams",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "logs:DescribeLogGroups",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })

  vpc_flow_assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com",
        },
      },
    ],
  })

  ec2_assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}
module "vpc_main" {
  source                   = "./module/vpc"
  availability_zones       = ["eu-west-1a", "eu-west-1b"]
  cidr_block               = "10.0.0.0/16"
  module_id                = 0
  name                     = "main"
  genarate_ipv6_cidr_block = true
}

module "vpc_backup" {
  source             = "./module/vpc"
  availability_zones = ["eu-west-1c"]
  cidr_block         = "10.1.0.0/16"
  module_id          = 1
  name               = "backup"
}

module "peering" {
  source                        = "./module/peering"
  primary_vpc_id                = module.vpc_main.vpc_id
  primary_main_route_table_id   = module.vpc_main.public_route_table_id
  primary_cidr_block            = module.vpc_main.cidr_block
  secondary_vpc_id              = module.vpc_backup.vpc_id
  secondary_main_route_table_id = module.vpc_backup.public_route_table_id
  secondary_cidr_block          = module.vpc_backup.cidr_block
}

module "sg_main" {
  source              = "./module/sg"
  ip_address          = var.ip_address
  public_ssh_sg_name  = "public_ssh_main"
  http_sg_name        = "http_main"
  private_ssh_sg_name = "private_ssh_main"
  vpc_id              = module.vpc_main.vpc_id
}

module "bastion_host" {
  source          = "./module/ec2"
  subnet_id       = module.vpc_main.public_subnets[0]
  security_groups = [module.sg_main.bastion_allow_ssh, module.sg_main.http]
  instance_type   = "t2.micro"
  ami             = "ami-0766b4b472db7e3b9"
  user_data       = local.user_data
  key_name        = data.aws_key_pair.my_key.key_name
  tags = {
    Name = "bastion"
  }
}

module "ec2_role" {
  source             = "./module/role/ec2"
  policy_name        = "s3_policy"
  policy_description = "Allow access to S3"
  policy_document    = local.s3_policy_document
  assume_role_policy = local.ec2_assume_role_policy
  role_name          = "s3_access"
  profile_name       = "s3_access"
}

module "private_host" {
  source                = "./module/ec2"
  subnet_id             = module.vpc_main.private_subnets[0]
  security_groups       = [module.sg_main.private_ssh]
  instance_type         = "t2.micro"
  ami                   = "ami-0766b4b472db7e3b9"
  key_name              = data.aws_key_pair.my_key.key_name
  instance_profile_name = module.ec2_role.instance_profile_name
  tags = {
    Name = "db"
  }
}

module "private_host_backup" {
  source                = "./module/ec2"
  subnet_id             = module.vpc_main.private_subnets[1]
  security_groups       = [module.sg_main.private_ssh]
  instance_type         = "t2.micro"
  ami                   = "ami-0766b4b472db7e3b9"
  key_name              = data.aws_key_pair.my_key.key_name
  instance_profile_name = module.ec2_role.instance_profile_name
  tags = {
    Name = "db_backup"
  }
}

module "endpoints" {
  source                 = "./module/endpoints"
  vpc_id                 = module.vpc_main.vpc_id
  private_route_table_id = module.vpc_main.private_route_table_id
  region                 = var.aws_region
}
module "sg_backup" {
  source              = "./module/sg"
  ip_address          = var.ip_address
  private_ssh_sg_name = "private_ssh_backup"
  public_ssh_sg_name  = "public_ssh_backup"
  http_sg_name        = "http_backup"
  vpc_id              = module.vpc_backup.vpc_id
}

module "web" {
  source          = "./module/ec2"
  subnet_id       = module.vpc_backup.public_subnets[0]
  security_groups = [module.sg_backup.bastion_allow_ssh, module.sg_backup.http]
  instance_type   = "t2.micro"
  ami             = "ami-0766b4b472db7e3b9"
  key_name        = data.aws_key_pair.my_key.key_name
  tags = {
    Name = "web"
  }
}

module "bucket" {
  source = "./module/bucket"
  name   = "vpc-flow-logs-${module.vpc_main.vpc_id}"
}

module "bucket_athena" {
  source = "./module/bucket"
  name   = "vpc-flow-logs-athena-${module.vpc_main.vpc_id}"
}

module "cw_log" {
  source = "./module/cloudwatch"
  name   = "vpc-flow-logs"
}

module "vpc_flow_role" {
  source             = "./module/role/vpc"
  policy_name        = "vpc_flow_policy"
  policy_document    = local.vpc_log_policy_document
  assume_role_policy = local.vpc_flow_assume_role_policy
  role_name          = "vpc_flow"
}

module "flow_logs_cw" {
  source               = "./module/flow_logs"
  vpc_id               = module.vpc_main.vpc_id
  log_destination_type = "cloud-watch-logs"
  role_arn             = module.vpc_flow_role.arn
  flow_log_name        = "vpc-flow-logs-cw"
  traffic_type         = "ALL"
  log_destination      = module.cw_log.arn
}

module "flow_logs_s3" {
  source               = "./module/flow_logs"
  vpc_id               = module.vpc_main.vpc_id
  log_destination_type = "s3"
  role_arn             = ""
  flow_log_name        = "vpc-flow-logs-s3"
  traffic_type         = "ALL"
  log_destination      = module.bucket.arn
}

output "bastion_ip" {
  value = module.bastion_host.public_ip
}

output "private_ip_db_backup" {
  value = module.private_host_backup.private_ip
}

output "web_ip" {
  value = module.web.public_ip
}
