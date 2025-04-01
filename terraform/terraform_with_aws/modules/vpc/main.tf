variable "task_name" {
  description = "The name of the task"
  type        = string
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "test-vpc"
  }
}


# Create a Security Group attached to the VPC
resource "aws_security_group" "security_group" {
  name        = "Security_Group"
  description = "Allow inbound traffic on ports 22 (SSH), 80 (HTTP), 443 (HTTPS)"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all Ipv4 traffic from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic (any protocol)
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group"
  }
}


# Create and attach subnets to the VPC
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-1a"
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-subnet-1b"
  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet-1b"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id 
  tags = {
    Name = "internet-gateway"
  }
}

# Route Tables
resource "aws_route_table" "rt_public_subnet" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public-subnet-route-table"
  }
}

resource "aws_route_table" "rt_private_subnet_1a" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-subnet-rt-1a"
  }
}

resource "aws_route_table" "rt_private_subnet_1b" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-subnet-rt-1b"
  }
}

# Route allow internet access
resource "aws_route" "route_public_subnet" {
  route_table_id            = aws_route_table.rt_public_subnet.id
  destination_cidr_block    = "0.0.0.0/22"
  gateway_id                = aws_internet_gateway.igw.id
}

# Route Table Associations
resource "aws_route_table_association" "associate_public_rt_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.rt_public_subnet.id
}

resource "aws_route_table_association" "associate_public_rt_1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.rt_public_subnet.id
}

resource "aws_route_table_association" "associate_private_rt_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.rt_private_subnet_1a.id
}

resource "aws_route_table_association" "associate_private_rt_1b" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.rt_private_subnet_1b.id
}

# VPC Endpoint for S3
resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  tags = {
    Name = "vpc-endpoint-s3"
  }
}

# Modify the VPC endpoint to add the private route tables to S3
resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_association_1a" {
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint_s3.id
  route_table_id  = aws_route_table.rt_private_subnet_1a.id
}

# Modify the VPC endpoint to add the private route tables to S3
resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_association_1b" {
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint_s3.id
  route_table_id  = aws_route_table.rt_private_subnet_1b.id
}
