variable "region" {
  type        = string
  description = "AWS region for deployment"
}

variable "aws_ami" {
  type        = string
  description = "AMI ID for EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
  default     = 2
}

variable "instance_name_prefix" {
  type        = string
  description = "Prefix for instance names"
  default     = "varrow-compute"
}

variable "key_pair_name" {
  type        = string
  description = "EC2 Key Pair name for SSH access"
  default     = ""
}

variable "enable_detailed_monitoring" {
  type        = bool
  description = "Enable detailed CloudWatch monitoring"
  default     = false
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
}

variable "subnet_type" {
  type        = string
  description = "Subnet type for instances: public or private"
  default     = "private"
  validation {
    condition     = contains(["public", "private"], var.subnet_type)
    error_message = "Subnet type must be either 'public' or 'private'."
  }
}

variable "enable_public_ip" {
  type        = bool
  description = "Enable public IP assignment for instances"
  default     = false
}
