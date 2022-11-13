resource "aws_vpc" "kube-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Kubernetes VPC"
  }
}

resource "aws_subnet" "kube-public-subnet" {
  vpc_id                  = aws_vpc.kube-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.1.0/24"
  tags = {
    Name = "Kubernetes public subnet"
  }
}

resource "aws_internet_gateway" "kube-igw" {
  vpc_id = aws_vpc.kube-vpc.id
  tags = {
    Name = "Kubernetes internet gateway"
  }
}

resource "aws_route_table" "external-rt" {
  vpc_id = aws_vpc.kube-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kube-igw.id
  }

  tags = {
    Name = "External IP routing"
  }
}

resource "aws_route_table_association" "public-routing" {
  subnet_id      = aws_subnet.kube-public-subnet.id
  route_table_id = aws_route_table.external-rt.id
}
