resource "aws_security_group" "kube-control-ssh-sg" {
  vpc_id      = aws_vpc.kube-vpc.id
  name        = "Kube SSH"
  description = "SHH access to Kube controller"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Kubernetes SSH security group"
  }
}

resource "aws_security_group" "kube-outbound" {
  vpc_id = aws_vpc.kube-vpc.id
  name   = "Kube Outbound sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "allow outbound connections"
  }
}

resource "aws_security_group" "kube-cluster" {
  vpc_id = aws_vpc.kube-vpc.id
  name   = "Kube Cluster connection"
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    "Name" = "allow nodes to join the cluster"
  }
}
