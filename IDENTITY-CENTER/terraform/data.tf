data "aws_iam_policy" "bedrock_full_access_managed_policy" {
  name = "AmazonBedrockFullAccess"
}

data "aws_iam_policy" "ec2_readonly_managed_policy" {
  name = "AmazonEC2ReadOnlyAccess"
}

data "aws_iam_policy" "poweruser_managed_policy" {
  name = "PowerUserAccess"
}

data "aws_iam_policy" "s3_readonly_access_managed_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}