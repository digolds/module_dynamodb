variable "name" {
  description = "(Required) The name of the table, this needs to be unique within a region."
  type        = string
}

variable "tags" {
  description = "A map of tags to populate on the created table."
  type        = map
  default     = {}
}
