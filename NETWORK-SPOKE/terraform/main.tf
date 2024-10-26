data "aws_ssm_parameter" "environment" {
  name = "/aft/account-request/custom-fields/environment"
}

data "aws_ssm_parameter" "ipam_nvirginia" {
  provider = aws.aft_management
  name     = "/aft/network/ipam/pool/nvirginia/${data.aws_ssm_parameter.environment.value}"
}

data "aws_ssm_parameter" "ipam_oregon" {
  provider = aws.aft_management
  name     = "/aft/network/ipam/pool/oregon/${data.aws_ssm_parameter.environment.value}"
}

data "aws_vpc_ipam_pool" "ipam_nvirginia" {
  filter {
    name   = "description"
    values = ["nvirginia-${data.aws_ssm_parameter.environment.value}"]
  }

  filter {
    name   = "address-family"
    values = ["ipv4"]
  }
}

data "aws_vpc_ipam_pool" "ipam_oregon" {
  filter {
    name   = "description"
    values = ["oregon-${data.aws_ssm_parameter.environment.value}"]
  }

  filter {
    name   = "address-family"
    values = ["ipv4"]
  }
}

# VPCs
module "vpc_nvirginia" {
  source  = "aws-ia/vpc/aws"
  version = "4.4.2"

  name                    = "AFT-Vended"
  az_count                = 3
  vpc_ipv4_ipam_pool_id   = data.aws_vpc_ipam_pool.ipam_nvirginia.id
  vpc_ipv4_netmask_length = 24

  subnets = {
    endpoints = { netmask = 28 }
    private   = { netmask = 28 }
  }
}

module "vpc_oregon" {
  source  = "aws-ia/vpc/aws"
  version = "4.4.2"
  providers = {
    aws = aws.us_west_2
  }

  name                    = "AFT-Vended"
  az_count                = 3
  vpc_ipv4_ipam_pool_id   = data.aws_vpc_ipam_pool.ipam_oregon.id
  vpc_ipv4_netmask_length = 24

  subnets = {
    endpoints = { netmask = 28 }
    private   = { netmask = 28 }
  }
}