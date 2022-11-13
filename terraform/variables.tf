variable "key-path" {
  type    = string
  default = "terraform.pem"
}

variable "key-pair" {
  type    = string
  default = "terraform"
}

variable "remote-user" {
  type    = string
  default = "ubuntu"
}

variable "controller-playbook" {
  type    = string
  default = "ansible/k8s-controller.yml"
}

variable "worker-playbook" {
  type    = string
  default = "ansible/k8s-worker.yml"
}
