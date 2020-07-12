terraform {
  required_version = "= 0.12.19"
}

resource "aws_dynamodb_table" "basic_dynamodb_table" {
  name           = var.name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  range_key      = var.range_key

  dynamic "global_secondary_index" {
    for_each = {
      for g_index in var.global_secondary_indexes :
      g_index["name"] => g_index
    }
    content {
      name               = global_secondary_index.value["name"]
      hash_key           = global_secondary_index.value["hash_key"]
      range_key          = global_secondary_index.value["range_key"]
      write_capacity     = global_secondary_index.value["write_capacity"]
      read_capacity      = global_secondary_index.value["read_capacity"]
      projection_type    = global_secondary_index.value["projection_type"]
      non_key_attributes = global_secondary_index.value["non_key_attributes"]
    }
  }

  dynamic "local_secondary_index" {
    for_each = {
      for l_index in var.local_secondary_indexes :
      l_index["name"] => l_index
    }
    content {
      name               = local_secondary_index.value["name"]
      range_key          = local_secondary_index.value["range_key"]
      projection_type    = local_secondary_index.value["projection_type"]
      non_key_attributes = local_secondary_index.value["non_key_attributes"]
    }
  }

  dynamic "attribute" {
    for_each = {
      for a in var.attributes :
      a["name"] => a
    }
    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
    }
  }

  dynamic "ttl" {
    for_each = (length(var.ttl_attribute_name) == 0 ? [] : [{
      attribute_name = var.ttl_attribute_name
      enabled        = true
    }, ])
    content {
      enabled        = ttl.value["enabled"]
      attribute_name = ttl.value["attribute_name"]
    }
  }

  dynamic "replica" {
    for_each = {
      for rn in var.replicas :
      rn => rn
    }
    content {
      region_name = replica.value
    }
  }

  stream_enabled   = var.stream["stream_enabled"]
  stream_view_type = var.stream["stream_view_type"]

  tags = var.tags
}
