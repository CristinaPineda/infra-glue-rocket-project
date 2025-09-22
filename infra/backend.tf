terraform {
  backend "s3" {
    bucket         = "rocket-project-statefiles"
    key            = "glue-catalog/terraform.tfstate"
    region         = "sa-east-1"
    encrypt        = true
    dynamodb_table = "rocket-projec-terraform-lock"
  }
}
