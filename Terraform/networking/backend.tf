terraform {
  backend "s3" {
    bucket         = "varrow-academy-cloud-networking-terraform-backend-us-east-1"
    key            = "networking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "Lock_Terraform"
  }
}
