# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16" # Replace with your desired VPC CIDR block
  enable_dns_support   = true          # Enable DNS support
  enable_dns_hostnames = true          # Enable DNS support

  tags = {
    Name = "${local.prefix}-vpc" # Replace with your desired VPC name
  }
}

# Create public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.prefix}-public-subnet-1"
  }
}

# Create public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.prefix}-public-subnet-2"
  }
}


# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.prefix}-internet-gateway" # Replace with your desired internet gateway name
  }
}

# Create route table for public subnet 1
resource "aws_route_table" "public_1" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.prefix}-aws-route-table"
  }
}

# Create association between route table and public subnet 1
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_1.id
}

# Create route from public internet through internet gateway to public subnet 1
resource "aws_route" "public_internet_1" {
  route_table_id         = aws_route_table.public_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# resource "aws_eip" "public_1" {
#   domain = "vpc"

#   tags = {
#     Name = "${local.prefix}-public-1"
#   }
# }

###########
# Create route table for public subnet 2
resource "aws_route_table" "public_2" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.prefix}-aws-route-table"
  }
}

# Create association between route table and public subnet 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_2.id
}

# Create route from public internet through internet gateway to public subnet 2
resource "aws_route" "public_internet_2" {
  route_table_id         = aws_route_table.public_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# # Create elastic IP
# resource "aws_eip" "public_2" {
#   domain = "vpc"

#   tags = {
#     Name = "${local.prefix}-public-2"
#   }
# }
