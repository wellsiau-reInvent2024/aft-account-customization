provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::681473994475:role/955372440160-test"
  }
  alias = "vending_account1"
}

run "basic_test" {  
  command = apply

  providers = {
    aws = aws.vending_account1
  }
}
