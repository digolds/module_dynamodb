variable "name" {
  description = "(Required) The name of the table, this needs to be unique within a region."
  type        = string
}

variable "ttl_attribute_name" {
  description = ""
  type        = string
  default     = ""
}

variable "billing_mode" {
  description = ""
  type        = string
  default     = ""
}

variable "hash_key" {
  description = ""
  type        = string
}

variable "range_key" {
  description = ""
  type        = string
  default     = ""
}

variable "read_capacity" {
  description = ""
  type        = number
  default     = 1
}

variable "write_capacity" {
  description = ""
  type        = number
  default     = 1
}

variable "attributes" {
  description = ""
  type = list(object(
    {
      name = string
      type = string
    }
  ))
}

variable "global_secondary_indexes" {
  description = ""
  type = list(object(
    {
      name               = string
      hash_key           = string
      range_key          = string
      write_capacity     = number
      read_capacity      = number
      projection_type    = string
      non_key_attributes = list(string)
    }
  ))
  default = []
}

variable "local_secondary_indexes" {
  description = ""
  type = list(object(
    {
      name               = string
      range_key          = string
      projection_type    = string
      non_key_attributes = list(string)
    }
  ))
  default = []
}


variable "tags" {
  description = "A map of tags to populate on the created table."
  type        = map
  default     = {}
}
