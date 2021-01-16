provider "aws" {
  region = "us-east-1"
  # access_key = "AKIAIOT5RRSABGTAJDD" # Don't hard code security credentials. The ones provided are dummy and are for demo purpose only
  # secret_key = "KTlIoUalLGsaCC5dqTeDWt11j"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "test"
}

resource "aws_instance" "terraform_ec2" {
  ami           = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform-EC2"
  }
}

output "instance_ip" {
  value = aws_instance.terraform_ec2.public_ip
}

output "instance_url" {
  value = "http://${aws_instance.terraform_ec2.public_ip}"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Terraform-VPC"
  }
}

resource "aws_subnet" "terraform_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    "Name" = "Terraform-Subnet"
  }
}

resource "aws_subnet" "terraform_subnet_2" {
  vpc_id     = aws_vpc.terraform_vpc_2.id
  cidr_block = "10.1.1.0/24"
  tags = {
    "Name" = "Terraform-Subnet-2"
  }
}

resource "aws_vpc" "terraform_vpc_2" {
  cidr_block = "10.1.0.0/16"
  tags = {
    "Name" = "Terraform-VPC-2"
  }
}