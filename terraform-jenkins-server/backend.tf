#backend.tf configuration

terraform {
  backend "s3" {
    bucket = "aws-bucket27"  #Manually created s3 bucket for storing state file
    region = "us-east-1"
    key = "terraform/terraform.tfstate"  #The path where the state file is stored
    dynamodb_table = "terraform_lock"  #Enables state locking to prevent concurrent modifications
    encrypt        = true  #Enables encryption for the state file at rest
  }
}