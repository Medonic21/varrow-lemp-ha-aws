module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Cloud_vpc"
  cidr =  var.vpc_CIDR

  azs = ["${var.region}a", "${var.region}b"]

  public_subnets  = [var.Public_Subnet_1_CIDR, var.Public_Subnet_2_CIDR]

  private_subnets = [var.Private_Subnet_1_CIDR, var.Private_Subnet_2_CIDR]

  database_subnets = [var.intra_Subnet_1_CIDR, var.intra_Subnet_2_CIDR]

  enable_nat_gateway = true

  single_nat_gateway = true 

  tags = {
    Environment = "dev"
  }
}