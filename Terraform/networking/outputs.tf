
output varrow_vpc {
value = aws_vpc.varrow_vpc.id
}

output Public_Subnet_1{
  value = aws_subnet.Public_Subnet_1.id
}

output Public_Subnet_2 {
  value = aws_subnet.Public_Subnet_2.id
}

output Private_Subnet_1 {
  value = aws_subnet.Private_Subnet_1.id
}

output Private_Subnet_2 {
  value = aws_subnet.Private_Subnet_2.id
}

output intra_Subnet_1 {
  value = aws_subnet.intra_Subnet_1.id
}

output intra_Subnet_2 {
  value = aws_subnet.intra_Subnet_2.id
}

