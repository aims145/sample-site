# VPC
module "vpc" {
  source   = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = var.env
  region   = var.region
  zones    = var.zones
}

## Security groups
