########################################
# NETWORKING - VPC, Subnets, IGW, Routing
########################################
# Variable for subnet CIDR prefixes

# Create a VPC
resource "aws_vpc" "first_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Web_vpc"
  }
}

# Create Subnets
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.first_vpc.id
  cidr_block        = var.subnet_prefix[0]
  availability_zone = "us-east-1a"
  tags = {
    Name = "Prod_subnet"
  }
}

resource "aws_subnet" "dev_subnet" {
  vpc_id            = aws_vpc.first_vpc.id
  cidr_block        = var.subnet_prefix[1]
  availability_zone = "us-east-1b"
  tags = {
    Name = "Dev_subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.first_vpc.id
  tags = {
    Name = "first_igw"
  }
}

# Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.first_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "prod_route"
  }
}

# Route Table Associations
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.route_table.id
}