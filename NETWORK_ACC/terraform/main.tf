# data source for current aws region
data "aws_region" "current" {}

# data source for current aws account
data "aws_caller_identity" "current" {}

# data aws organizations organization
data "aws_organizations_organization" "org" {}

# AWS-IA (Integration Automation) IPAM module
module "ipam" {
  source  = "aws-ia/ipam/aws"
  version = "2.1.0"

  top_cidr       = ["10.0.0.0/8"]
  address_family = "ipv4"
  create_ipam    = true
  top_name       = "AFT Managed IPAM"

  pool_configurations = {
    nvirginia = {
      name           = "nvirginia"
      description    = "US (${data.aws_region.current.name}) Region"
      netmask_length = 16
      locale         = data.aws_region.current.name

      sub_pools = {
        spoke = {
          name                 = "spoke-accounts"
          netmask_length       = 16
          ram_share_principals = [data.aws_organizations_organization.org.arn]
        }
      }
    }
  }
}

resource "aws_ssm_parameter" "ipam_pool" {
  provider = aws.aft_management
  name  = "/aft/network/ipam/pool/spokes/id"
  type  = "String"
  value = module.ipam.pools_level_2["usa/spoke"].id
}