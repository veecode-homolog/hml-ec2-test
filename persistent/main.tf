### DATA IMPORT

data "aws_vpc" "selected" {
  id = local.config.VPC_ID
}

data "aws_subnet" "selected" {
  id = local.config.SUBNET_ID
}

resource "aws_security_group" "web_security_group" {
  name        = "access_cluster_${local.config.cluster_name}_SG"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.selected.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    description = "EFS mount target"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    description = "Cluster Access"
    from_port   = 6550
    to_port     = 6550
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
  Template = "Platform_Ec2"
  }
}

resource "aws_eip" "webip" {
    vpc = true
    tags = {
    Name = "${local.config.cluster_name}-platform-eip"
    Template = "Platform_Ec2"
  }
}

output "instance_ip_addr" {
  value       = aws_eip.webip.public_ip
}