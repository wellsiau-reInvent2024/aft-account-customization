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

# ---------- AWS SECRETS MANAGER ----------

# IPAM Pool Secret
resource "aws_secretsmanager_secret" "ipam_pool" {
  name                    = "${data.aws_caller_identity.aws_networking_account.account_id}-ipam-pool-id"
  description             = "IPAM Pool (Networking Account)."
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ipam_pool" {
  secret_id     = aws_secretsmanager_secret.ipam_pool.id
  secret_string = module.ipam.pools_level_2["usa/spoke"].id
}


# KMS Key to encrypt the secrets
resource "aws_kms_key" "secrets_key" {
  description             = "KMS Secrets Key - Security Account."
  enable_key_rotation     = true
}

# KMS Policy
data "aws_iam_policy_document" "policy_kms_document" {
  statement {
    sid    = "Enable AWS Secrets Manager secrets decryption."
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:*"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.aws_networking_account.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"

      values = ["secretsmanager.${data.aws_region.current.name}.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:SecretARN"

      values = ["arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.aws_networking_account.id}:secret:*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"

      values = ["${data.aws_organizations_organization.org.id}"]
    }
  }

  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.aws_networking_account.id}:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.aws_networking_account.id}:root"]
    }
  }
}