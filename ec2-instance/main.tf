provider "aws" {
  region     = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile = "test"
}

# Subnet Prefix
variable "subnet_prefix" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
  type        = string
}

# VPC
resource "aws_vpc" "terraform_vpc_test" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Terraform-VPC-Test"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "terraform_gw_test" {
  vpc_id = aws_vpc.terraform_vpc_test.id
  tags = {
    "Name" = "Terraform-Internet-Gateway-Test"
  }
}

# Route Table
resource "aws_route_table" "terraform_route_table_test" {
  vpc_id = aws_vpc.terraform_vpc_test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gw_test.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.terraform_gw_test.id
  }

  tags = {
    "Name" = "Terraform-Route-Table-Test"
  }
}

# Subnet
resource "aws_subnet" "terraform_subnet_test" {
  vpc_id            = aws_vpc.terraform_vpc_test.id
  cidr_block        = var.subnet_prefix # "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "Terraform-Subnet-Test"
  }
}

# Route Table Association
resource "aws_route_table_association" "terraform_route_association_test" {
  subnet_id      = aws_subnet.terraform_subnet_test.id
  route_table_id = aws_route_table.terraform_route_table_test.id
}

# Security Group
resource "aws_security_group" "terraform_security_group_test" {
  name        = "allow_web_traffic"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.terraform_vpc_test.id
  ingress = [{
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    security_groups  = null
    prefix_list_ids  = null
    self             = null
    }, {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    security_groups  = null
    prefix_list_ids  = null
    self             = null
    }, {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    security_groups  = null
    prefix_list_ids  = null
    self             = null
  }]
  egress = [{
    description      = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    security_groups  = null
    prefix_list_ids  = null
    self             = null
  }]
  tags = {
    "Name" = "Terraform-Security-Group-Test"
  }
}

# Network Interface
resource "aws_network_interface" "terraform_network_interface_test" {
  subnet_id       = aws_subnet.terraform_subnet_test.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.terraform_security_group_test.id]
  # attachment {
  #   instance = aws_instance.terraform_ec2_test.id
  #   device_index = 1
  # }
}

# Elastic IP
resource "aws_eip" "terraform_eip_test" {
  vpc                       = true
  network_interface         = aws_network_interface.terraform_network_interface_test.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.terraform_gw_test, aws_instance.terraform_ec2_test]
}

output "instance_public_ip" {
  value = "http://${aws_eip.terraform_eip_test.public_ip}" 
}

# Instance creation and configuration
resource "aws_instance" "terraform_ec2_test" {
  ami               = "ami-0885b1f6bd170450c"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "instance_aws"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.terraform_network_interface_test.id
  }

  # user_data = <<EOF
  #   #!/bin/bash
  #   sudo apt-get update -y && sudo apt-get upgrade -y
  #   sudo apt-get install nginx -y
  #   sudo systemctl start nginx
  #   sudo systemctl enable nginx
  #   sudo ufw allow 'Nginx HTTP'
  #   sudo ufw allow 'OpenSSH'
  #   sudo systemctl enable ufw
  #   sudo bash -c "echo Hola Mundo!" > /var/www/html/index.html
  #   EOF
  user_data = file("install_nginx.sh")

  tags = {
    Name = "Terraform-EC2-Test"
  }
}

output "instance_private_ip" {
  value = aws_instance.terraform_ec2_test.private_ip
}

output "instance_id" {
  value = aws_instance.terraform_ec2_test.id
}