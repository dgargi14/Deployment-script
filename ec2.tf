provider "aws" {
  region = "ap-south-1"
}

# Security Group for Jenkins Master
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
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

# Security Group for Application Node
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow SSH and Tomcat"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Tomcat"
    from_port   = 8081
    to_port     = 8081
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

# Jenkins Master Instance
resource "aws_instance" "jenkins_master" {
  ami           = "ami-02d26659fd82cf299"   # Ubuntu 24.04 LTS
  instance_type = "t3.micro"
  key_name      = "mk"                      # your key pair name
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "jenkins-master"
  }
}

# Application Node Instance
resource "aws_instance" "app_node" {
  ami           = "ami-02d26659fd82cf299"   # Ubuntu 24.04 LTS
  instance_type = "t3.micro"
  key_name      = "mk"                      # your key pair name
  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "app-node"
  }
}

