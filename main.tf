provider "aws" {
  region = "us-east-1"
}

# -------------------------
# VPC
# -------------------------

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform-VPC"
  }
}

# -------------------------
# Public Subnet
# -------------------------

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Terraform-Public-Subnet"
  }
}

# -------------------------
# Internet Gateway
# -------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Terraform-IGW"
  }
}

# -------------------------
# Public Route Table
# -------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Terraform-Public-Route-Table"
  }
}

# -------------------------
# Route Table Association
# -------------------------

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -------------------------
# S3 Bucket
# -------------------------

resource "aws_s3_bucket" "my_bucket" {
  bucket_prefix = "terraform-s3-"

  tags = {
    Name = "Terraform-S3-Bucket"
  }
}

# -------------------------
# Existing EC2
# -------------------------

resource "aws_instance" "my_ec2" {
  ami           = "ami-0354c98ae10b02961"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-EC2"
  }
}