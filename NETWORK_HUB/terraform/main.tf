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
  top_name       = "Organization IPAM Test"

  pool_configurations = {
    nvirginia = {
      name           = "nvirginia"
      netmask_length = 16
      locale         = "us-east-1"

      sub_pools = {
        sandbox = {
          name                 = "sandbox"
          netmask_length       = 20
          ram_share_principals = [data.aws_organizations_organization.org.arn]
        }
        prod = {
          name                 = "prod"
          netmask_length       = 20
          ram_share_principals = [data.aws_organizations_organization.org.arn]
        }
      }
    }
    oregon = {
      name           = "oregon"
      netmask_length = 16
      locale         = "us-west-2"

      sub_pools = {
        sandbox = {
          name                 = "sandbox"
          netmask_length       = 20
          ram_share_principals = [data.aws_organizations_organization.org.arn]
        },
        prod = {
          name                 = "prod"
          netmask_length       = 20
          ram_share_principals = [data.aws_organizations_organization.org.arn]
        }
      }
    }
  }
}

# ---------- SSN PARAMETER ------------
resource "aws_ssm_parameter" "ipam_pool_ids" {
  provider = aws.aft_management

  for_each = toset(["nvirginia/sandbox", "nvirginia/prod", "oregon/sandbox", "oregon/prod"])

  name  = "/aft/network/ipam/pool/${each.key}"
  type  = "String"
  value = module.ipam.pools_level_2[each.key].id
}