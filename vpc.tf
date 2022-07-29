##VPC

resource "aws_vpc" "sagar-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
  tags = {
    Name = "vpc-sagar"
  }
}

##Subnets

resource "aws_subnet" "subnet_id_1" {
  vpc_id     = aws_vpc.sagar-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet1"
  }
}
resource "aws_subnet" "subnet_id_2" {
  vpc_id     = aws_vpc.sagar-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "public-subnet2"
  }
}
resource "aws_subnet" "subnet_id_3" {
  vpc_id     = aws_vpc.sagar-vpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "subnet3"
  }
}

resource "aws_subnet" "subnet_id_4" {
  vpc_id     = aws_vpc.sagar-vpc.id
  cidr_block = "10.0.4.0/24"
  tags = {
    Name = "subnet4"
  }
}

##Internet Gateway for Public Subnet
resource "aws_internet_gateway" "sagar-ig" {
  vpc_id = aws_vpc.sagar-vpc.id
  tags = {
    Name = "sagar_ig"
  }
}

##NAT gateway
resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "sagar_nat" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.subnet_id_1.id
  tags = {
    Name = "sagar-nat"
  }
}

##route table
resource "aws_route_table" "sagar_route_public" {
  vpc_id = aws_vpc.sagar-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sagar-ig.id
  }
  tags = {
    Name = "sagar-route-public"
  }
}

resource "aws_route_table" "sagar_route_private" {
  vpc_id = aws_vpc.sagar-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.sagar_nat.id
  }
  tags = {
    Name = "sagar-route-private"
  }
}


##Route Table Association

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet_id_1.id
  route_table_id = aws_route_table.sagar_route_public.id
}
resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.subnet_id_2.id
  route_table_id = aws_route_table.sagar_route_public.id
}

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.subnet_id_3.id
  route_table_id = aws_route_table.sagar_route_private.id
}
resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.subnet_id_4.id
  route_table_id = aws_route_table.sagar_route_private.id
}

##NACL

/*
resource "aws_network_acl" "sagar" {
  vpc_id = aws_vpc.sagar-vpc.id
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "sagar_nacl"
  }
}
resource "aws_network_acl_association" "sagar1" {
  network_acl_id = aws_network_acl.sagar.id
  subnet_id      = aws_subnet.subnet_id_1.id
}

resource "aws_network_acl_association" "sagar2" {
  network_acl_id = aws_network_acl.sagar.id
  subnet_id      = aws_subnet.subnet_id_2.id
}

resource "aws_network_acl_association" "sagar3" {
  network_acl_id = aws_network_acl.sagar.id
  subnet_id      = aws_subnet.subnet_id_3.id
}

resource "aws_network_acl_association" "sagar4" {
  network_acl_id = aws_network_acl.sagar.id
  subnet_id      = aws_subnet.subnet_id_4.id
}
*/