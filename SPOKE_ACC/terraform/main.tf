# ---------- AWS ORGANIZATIONS AND ACCOUNT INFORMATION ----------
data "aws_caller_identity" "aws_networking_account" {}
data "aws_organizations_organization" "org" {}
data "aws_region" "current" {}

data "aws_ssm_parameter" "spoke_ipam_pool_id" {
  name = "/aft/account-request/custom-fields/ipam_pool_id"
}

# VPCs
module "vpcs" {
  source   = "aws-ia/vpc/aws"
  version  = "4.4.2"

  name                    = "AFT-Vended"
  az_count                = 3
  vpc_ipv4_ipam_pool_id   = data.aws_ssm_parameter.spoke_ipam_pool_id.value
  vpc_ipv4_netmask_length = 24

  subnets = {
    endpoints       = { netmask = 28 }
    private         = { netmask = 28 }
  }
}