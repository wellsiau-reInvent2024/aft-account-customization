# data ssm parameter 
data "aws_ssm_parameter" "ipam_pool_id" {
  name = "/aft/account-request/custom-fields/ipam_pool_id"
}

# AWS-IA (Integration Automation) VPC module
module "vpcs" {
  source   = "aws-ia/vpc/aws"
  version  = "4.4.2"

  name                    = "IPAM Vended VPC"
  az_count                = 3
  vpc_ipv4_ipam_pool_id   = data.aws_ssm_parameter.ipam_pool_id.value
  vpc_ipv4_netmask_length = 24

  subnets = {
    endpoints       = { netmask = 28 }
    private         = { netmask = 28 }
  }
}