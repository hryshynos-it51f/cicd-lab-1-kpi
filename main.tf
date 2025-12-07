provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "app_sg" {
  name        = "cicd_sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = "ami-04169656fea786776" # Ubuntu 22.04
  instance_type          = "t3.micro"
  key_name               = "id_rsa"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker

    docker pull kepalex/hryshyn-phd-repo:latest
    docker run -d -p 80:80 --name web kepalex/hryshyn-phd-repo:latest

    docker run -d --name watchtower \
      -v /var/run/docker.sock:/var/run/docker.sock \
      containrrr/watchtower --interval 30
  EOF

  tags = {
    Name = "cicd-lab2-instance"
  }
}
