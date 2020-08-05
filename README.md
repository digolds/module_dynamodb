# Infrastructure as Code for DynamoDB

This is Infrastructure as Code(based on Terraform) for provisioning DynamoDB instance. Any one who would like to accelerate the process of provisioning DynamoDB instance on top of AWS DynamoDB Service can give it a try.

This repository compose of 2 parts, one for **examples**, where you can get your hands dirty by walking through a bucket of demostrations of how to use the code. The other is **modules**, where the core code exist, and is referenced by all demos in **examples**.

In order to execute these demos, you should at least prepare the following prerequisites:

1. AWS account
2. Go environment
3. Terraform tool

Using the core code in **modules**, you are shipped with the following capabilities:

1. base table schema
2. local and global index
3. stream
4. replica
5. ttl(Time to Live)

Except for **1. base table schema**, the other features can configure optionally. For example you can just create a base table with the following code:

* Provision DynamoDB Table named my-test-table

```terraform
terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.58"
  region  = "ap-northeast-1"
}

module "dynamodb" {
  source       = "../../modules/dynamodb"
  name         = "my-test-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "GameTitle"
  attributes = [
    {
      name = "UserId"
      type = "S"
    },
    {
      name = "GameTitle"
      type = "S"
    },
    ]
}

output "dynamodb_instance" {
  value = module.dynamodb.dynamodb_instance
}
```

**NOTE**: you should replace `../../modules/dynamodb` with your location where the repository locates in your local computer or if you don't like to download this repository, you can replace with github url `github.com/2cloudlab/module_dynamodb//modules/dynamodb?ref=v0.0.1`, terraform will automatically clone the repository and refer it on behalf of you.

You can also create local & global indexes, tags, and ttl with the following code:

* Provision DynamoDB Table, local & global indexs, tags, and ttl

```terraform
terraform {
  required_version = "= 0.12.19"
}

provider "aws" {
  version = "= 2.58"
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
}

output "dynamodb_instance" {
  value = module.dynamodb.dynamodb_instance
}
```
