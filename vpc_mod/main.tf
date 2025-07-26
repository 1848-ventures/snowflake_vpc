# This Terraform configuration sets up a remote backend using sfor state management.
# It requires the AWS provider and specifies the S2 bucket, key, region, and encryption settings.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    tls = {
      source = "hashicorp/tls"
    }
    local = {
      source = "hashicorp/local"
    }
  }

  required_version = ">= 0.0.0"

  # backend "s3" {
  #   bucket       = "tuai-remote-tf-state"
  #   key          = "tuai-terraform-staging.tfstate"
  #   region       = "us-west-2"
  #   encrypt      = true
  #   use_lockfile = true
  # }
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "tuai-${module.vpc.environment}-key"
  public_key = tls_private_key.default.public_key_openssh
}

resource "local_file" "ssh_key" {
  content  = tls_private_key.default.private_key_pem
  filename = "tuai-${module.vpc.environment}-key.pem"
}


module "vpc" {
  source = "./modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "sg" {
  source = "./modules/sg"

  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
  vpc_cidr             = module.vpc.vpc_cidr
  snowflake_vpce_sg_id = module.snowflake_private_access.snowflake_vpce_sg_id
}

provider "aws" {
  region = var.region # Ensure this matches the region in your VPC module 
}











module "nacl" {
  source = "./modules/nacl"

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  environment = var.environment
}

module "snowflake_private_access" {
  source = "./modules/snowflake_private_access"

  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  private_subnet_cidrs = module.vpc.private_subnet_cidrs
  onprem_network_cidrs = var.onprem_network_cidrs
}

module "dns_resolver" {
  source = "./modules/dns_resolver"

  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  onprem_network_cidrs = var.onprem_network_cidrs
}

module "s3_endpoint" {
  source = "./modules/s3_endpoint"

  vpc_id          = module.vpc.vpc_id
  route_table_ids = module.vpc.private_route_table_ids
}







