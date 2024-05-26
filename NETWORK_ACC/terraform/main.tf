# ---------- AWS ORGANIZATIONS AND ACCOUNT INFORMATION ----------
data "aws_caller_identity" "aws_networking_account" {}
data "aws_organizations_organization" "org" {}
data "aws_region" "current" {}

# ---------- AMAZON VPC IPAM ----------
module "ipam" {
  source  = "aws-ia/ipam/aws"
  version = "2.0.0"

  top_cidr       = ["10.0.0.0/8"]
  address_family = "ipv4"
  create_ipam    = true
  top_name       = "Organization IPAM"

  pool_configurations = {
    usa = {
      name           = "usa"
      description    = "US ${data.aws_region.current.name} Region"
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

# ---------- SSN PARAMETER ------------
resource "aws_ssm_parameter" "ipam_pool" {
  provider = aws.aft_management
  name  = "/aft/network/ipam/pool/spokes/id"
  type  = "String"
  value = module.ipam.pools_level_2["usa/spoke"].id
}
