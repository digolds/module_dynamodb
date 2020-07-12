terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "us-east-2"
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  name   = "my-test-table"
  tags = {
    Env = "prod"
    App = "news"
  }
}

output "dynamodb_instance" {
  value = module.dynamodb.dynamodb_instance
}
