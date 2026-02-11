######----------------- Create VPC -----------#######
resource "aws_vpc" "varrow_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  
  tags = {
    Name = "varrowVPC"
  }
}

###----------- Create Route Tables (Public, Private, Intra)----------#####

################## Public Routes ######################
resource "aws_route_table" "Public_route" {
  vpc_id = aws_vpc.varrow_vpc.id

  route {
    cidr_block = var.vpc_CIDR
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "Public Route"
  }
}

################## Private Route ######################
resource "aws_route_table" "Private_route" {
  vpc_id = aws_vpc.varrow_vpc.id

  route {
    cidr_block = var.vpc_CIDR
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

   tags = {
    Name = "Private Route"
  }
}

################## Intra Route ######################
resource "aws_route_table" "intra_route" {
  vpc_id = aws_vpc.varrow_vpc.id

  route {
    cidr_block = var.vpc_CIDR
    gateway_id = "local"
  }

   tags = {
    Name = "Intra Route"
  }

}

###----------- Create Subnets Multi AZ (Public, Private, Intra)----------#####

################## Public Subnets AZ1 ######################

resource "aws_subnet" "Public_Subnet_1" {
  vpc_id            = aws_vpc.varrow_vpc.id
  cidr_block        = var.Public_Subnet_1_CIDR
  availability_zone = "${var.region}a"

  tags = {
    Name = "VA_Public_Subnet_1"
  }
}
################## Public Subnets AZ2 ######################
resource "aws_subnet" "Public_Subnet_2" {
  vpc_id            = aws_vpc.varrow_vpc.id
  cidr_block        = var.Public_Subnet_2_CIDR
  availability_zone = "${var.region}b"

  tags = {
    Name = "VA_Public_Subnet_2"
  }
}

################## Associate Public Route ######################
resource "aws_route_table_association" "Public_route_ass1" {
  subnet_id = aws_subnet.Public_Subnet_1.id 
  route_table_id = aws_route_table.Public_route.id
}

resource "aws_route_table_association" "Public_route_ass2" {
  subnet_id = aws_subnet.Public_Subnet_2.id 
  route_table_id = aws_route_table.Public_route.id
}


################## Private Subnets AZ1 ######################


resource "aws_subnet" "Private_Subnet_1" {
  vpc_id            = aws_vpc.varrow_vpc.id
  cidr_block        = var.Private_Subnet_1_CIDR
  availability_zone = "${var.region}a"

  tags = {
    Name = "VA_Private_Subnet_1"
  }
}

################## Private Subnets AZ1 ######################
resource "aws_subnet" "Private_Subnet_2" {
  vpc_id            = aws_vpc.varrow_vpc.id
  cidr_block        = var.Private_Subnet_2_CIDR
  availability_zone = "${var.region}b"

  tags = {
    Name = "VA_Private_Subnet_2"
  }
}

################## Associate Private Route ######################

resource "aws_route_table_association" "Private_route_ass1" {
  subnet_id = aws_subnet.Private_Subnet_1.id 
  route_table_id = aws_route_table.Private_route.id
}

resource "aws_route_table_association" "Private_route_ass2" {
  subnet_id = aws_subnet.Private_Subnet_2.id 
  route_table_id = aws_route_table.Private_route.id
}

################## Intra Subnets AZ1 ######################


resource "aws_subnet" "intra_Subnet_1" {
  vpc_id            = aws_vpc.varrow_vpc.id
  cidr_block        = var.intra_Subnet_1_CIDR
  availability_zone = "${var.region}a"

  tags = {
    Name = "VA_intra_Subnet_1"
  }
}

################## Intra Subnets AZ2 ######################

resource "aws_subnet" "intra_Subnet_2" {
  vpc_id            = aws_vpc.varrow_vpc.id
  cidr_block        = var.intra_Subnet_2_CIDR
  availability_zone = "${var.region}b"

  tags = {
    Name = "VA_intra_Subnet_2"
  }
}

################## Associate Intra Route ######################

resource "aws_route_table_association" "intra_route_ass1" {
  subnet_id = aws_subnet.intra_Subnet_1.id 
  route_table_id = aws_route_table.intra_route.id
}

resource "aws_route_table_association" "intra_route_ass2" {
  subnet_id = aws_subnet.intra_Subnet_2.id 
  route_table_id = aws_route_table.intra_route.id
}

#------------------- Create Internet & NAT Gateway ----------------------------#

########## Create Internet Gatway ###############3

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.varrow_vpc.id

  tags = {
    Name = "varrow_Internet_Gatway"
  }
}
########## Create Elastic IP ###############3

resource "aws_eip" "eip_nat" {
  depends_on = [ aws_internet_gateway.igw ]

  tags = {
    Name = "VArrow_EIP_NAT"
  }
}

########## Create Nat Gatway ###############3

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.Public_Subnet_1.id

  tags = {
    Name = "varrow_NAT_GW"
  }
  depends_on = [aws_eip.eip_nat]
}