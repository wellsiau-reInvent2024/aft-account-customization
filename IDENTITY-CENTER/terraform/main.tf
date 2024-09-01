// This is a template file for a basic deployment.
// Modify the parameters below with actual values

module "aws-iam-identity-center" {
  source  = "aws-ia/iam-identity-center/aws"
  version = "1.0.0"

  permission_sets = {
    SandboxAccess = {
      description      = "AWS power user access permissions.",
      session_duration = "PT4H",
      aws_managed_policies = [
        data.aws_iam_policy.poweruser_managed_policy.arn
      ]
      tags = { ManagedBy = "AFT" }
    },

    CustomPermissionAccess = {
      description      = "Custom permissions for genai workload",
      session_duration = "PT3H",
      aws_managed_policies = [
        data.aws_iam_policy.bedrock_full_access_managed_policy.arn,
        data.aws_iam_policy.ec2_readonly_managed_policy.arn
      ]
      tags = { ManagedBy = "AFT" }
    },
  }
}