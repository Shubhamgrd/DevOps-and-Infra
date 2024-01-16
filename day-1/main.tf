terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "example_server" {
  ami           = "ami-0d3f444bc76de0a79"
  instance_type = "t2.micro"

  tags = {
    Name = "Testing EC2"
  }
}