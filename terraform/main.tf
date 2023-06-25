terraform {
  backend "s3" {
    bucket         = "72kb-portfolio-app-tfstate"
    key            = "porfolio-app-tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "portfolio-app-tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }

}


provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

locals {
  prefix = var.prefix
}

output "app-endpoint" {
  value = aws_lb.my_load_balancer.dns_name
}
