# Data source to read networking module outputs from S3 state
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "varrow-academy-cloud-networking-terraform-backend-us-east-1"
    key    = "networking/terraform.tfstate"
    region = "us-east-1"
  }
}
