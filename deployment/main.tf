terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }


  backend "s3" {
    bucket         = "ecs-tfstate-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ecs-state-locking"
    encrypt        = true
  }


}