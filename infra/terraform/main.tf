# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
#   version = "2.77.0"

  name                 = "db-rds-fiap-3"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
#   enable_nat_gateway = true
#   enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "subnet_rds_fiap_3" {
  name       = "subnet-rds-fiap-3"
  subnet_ids = module.vpc.public_subnets

  tags = {
    name = "subnet-rds-fiap-3"
  }
}

resource "aws_security_group" "rds" {
  name   = "rds-fiap-3"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-rds-fiap-3"
  }
}

resource "aws_db_parameter_group" "parameter_rds" {
  name   = "parameterrdsfiap3"
  family = "sqlserver-ex-15.0"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "db-rds-fiap-3" {
  identifier             = "PosTechFiap"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  engine                 = "sqlserver"
  engine_version         = "15.00.4415.2.v1"
  username               = "postech"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.subnet_rds_fiap_3.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.parameter_rds.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}