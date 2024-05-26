provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::397352175627:role/955372440160-test"
  }
  alias = "network"
}

run "basic_plan" {  
  command = apply

  providers = {
    aws = aws.network
  }
}
