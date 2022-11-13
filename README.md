# Kubernetes cluster IAC deployment

## Useful AWS commands:

### connect cli to aws account

`aws configure`

paste in your access key ID and Access Key when prompted, then pick region (cloud guru needs to use us-east-1) and format - json is the default

### generate key pair for EC2 ssh connections

`aws ec2 create-key-pair --key-name terraform --query "KeyMaterial" --output text > terraform.pem`

(run chmod 400 after this to set permissions on the local file)

### add node to cluster

`kubeadm token create --print-join-command`
