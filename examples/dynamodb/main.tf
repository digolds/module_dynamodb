terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.46"
  region  = "ap-northeast-1"
}

module "dynamodb" {
  source       = "../../modules/dynamodb"
  name         = "my-test-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "GameTitle"
  tags = {
    Env = "prod"
    App = "news"
  }
  ttl_attribute_name = "abc"
  attributes = [
    {
      name = "UserId"
      type = "S"
    },
    {
      name = "GameTitle"
      type = "S"
    },
    {
      name = "TopScore"
      type = "N"
  }, ]
  global_secondary_indexes = [{
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }, ]
  local_secondary_indexes = [
    {
      name               = "LocalGameTitleIndex"
      range_key          = "TopScore"
      projection_type    = "INCLUDE"
      non_key_attributes = ["GameTitle"]
    },
  ]
  replicas = ["us-east-2", ]
}

output "dynamodb_instance" {
  value = module.dynamodb.dynamodb_instance
}
