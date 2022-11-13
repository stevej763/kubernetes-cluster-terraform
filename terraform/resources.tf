
resource "aws_instance" "k8s-controller" {
  ami           = "ami-0c4f7023847b90238"
  instance_type = "t2.medium"
  vpc_security_group_ids = [
    aws_security_group.kube-control-ssh-sg.id,
    aws_security_group.kube-outbound.id,
    aws_security_group.kube-cluster.id
  ]
  subnet_id = aws_subnet.kube-public-subnet.id
  key_name  = var.key-pair
  tags = {
    Name = "Kubernetes controller"
  }

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname k8s-controller"]
    connection {
      type        = "ssh"
      user        = var.remote-user
      private_key = file(var.key-path)
      host        = aws_instance.k8s-controller.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.remote-user} -i ${aws_instance.k8s-controller.public_ip}, --private-key ${var.key-path} ${var.controller-playbook}"
  }
}

resource "aws_instance" "k8s-worker-1" {
  ami           = "ami-0c4f7023847b90238"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.kube-public-subnet.id
  vpc_security_group_ids = [
    aws_security_group.kube-control-ssh-sg.id,
    aws_security_group.kube-outbound.id
  ]
  key_name = var.key-pair
  tags = {
    Name = "Kubernetes worker 1"
  }
  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname k8s-worker-1"]
    connection {
      type        = "ssh"
      user        = var.remote-user
      private_key = file(var.key-path)
      host        = aws_instance.k8s-worker-1.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.remote-user} -i ${aws_instance.k8s-worker-1.public_ip}, --private-key ${var.key-path} ${var.worker-playbook}"
  }
}

resource "aws_instance" "k8s-worker-2" {
  ami           = "ami-0c4f7023847b90238"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.kube-public-subnet.id
  vpc_security_group_ids = [
    aws_security_group.kube-control-ssh-sg.id,
    aws_security_group.kube-outbound.id
  ]
  key_name = var.key-pair
  tags = {
    Name = "Kubernetes worker 2"
  }
  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname k8s-worker-2"]
    connection {
      type        = "ssh"
      user        = var.remote-user
      private_key = file(var.key-path)
      host        = aws_instance.k8s-worker-2.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.remote-user} -i ${aws_instance.k8s-worker-1.public_ip}, --private-key ${var.key-path} ${var.worker-playbook}"
  }
}

output "controller-public-ip" {
  value = aws_instance.k8s-controller.public_ip
}
output "controller-private-ip" {
  value = aws_instance.k8s-controller.private_ip
}

output "worker-1-public-ip" {
  value = aws_instance.k8s-worker-1.public_ip
}

output "worker-1-private-ip" {
  value = aws_instance.k8s-worker-1.private_ip
}

output "worker-2-public-ip" {
  value = aws_instance.k8s-worker-2.public_ip
}

output "worker-2-private-ip" {
  value = aws_instance.k8s-worker-2.private_ip
}
