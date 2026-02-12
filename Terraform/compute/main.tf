# Reference to networking outputs from remote state
locals {
  vpc_id               = data.terraform_remote_state.networking.outputs.varrow_vpc
  public_subnet_1_id   = data.terraform_remote_state.networking.outputs.Public_Subnet_1
  public_subnet_2_id   = data.terraform_remote_state.networking.outputs.Public_Subnet_2
  private_subnet_1_id  = data.terraform_remote_state.networking.outputs.Private_Subnet_1
  private_subnet_2_id  = data.terraform_remote_state.networking.outputs.Private_Subnet_2
  intra_subnet_1_id    = data.terraform_remote_state.networking.outputs.intra_Subnet_1
  intra_subnet_2_id    = data.terraform_remote_state.networking.outputs.intra_Subnet_2

  selected_subnets = var.subnet_type == "public" ? [
    local.public_subnet_1_id,
    local.public_subnet_2_id
  ] : [
    local.private_subnet_1_id,
    local.private_subnet_2_id
  ]
}

#################################################################################
# ALB Security Group
#################################################################################
resource "aws_security_group" "alb_sg" {
  name_prefix = "varrow-alb-sg-"
  description = "Security group for Application Load Balancer"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS access from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "varrow-alb-sg"
    Environment = var.environment
    Module      = "compute"
    Component   = "load_balancer"
  }
}

#################################################################################
# EC2 Security Group
#################################################################################
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.instance_name_prefix}-sg-"
  description = "Security group for EC2 instances"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "Allow HTTP from ALB security group"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "Allow HTTPS from ALB security group"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access for management"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.instance_name_prefix}-sg"
    Environment = var.environment
    Module      = "compute"
    Component   = "web_server"
  }
}

#################################################################################
# RDS Security Group
#################################################################################
resource "aws_security_group" "rds_sg" {
  name_prefix = "varrow-rds-sg-"
  description = "Security group for RDS MariaDB database"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
    description     = "Allow MariaDB access from EC2 security group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "varrow-rds-sg"
    Environment = var.environment
    Module      = "compute"
    Component   = "database"
  }
}


#################################################################################
# EC2 Instances
#################################################################################
resource "aws_instance" "compute_instances" {
  count                = var.instance_count
  ami                  = var.aws_ami
  instance_type        = var.instance_type
  subnet_id            = local.selected_subnets[count.index % length(local.selected_subnets)]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name             = var.key_pair_name != "" ? var.key_pair_name : null
  associate_public_ip_address = var.enable_public_ip
  monitoring           = var.enable_detailed_monitoring

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name        = "${var.instance_name_prefix}-${count.index + 1}"
    Environment = var.environment
    Module      = "compute"
  }

  lifecycle {
    create_before_destroy = true
  }
}
