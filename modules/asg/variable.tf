variable "subnet_ids" {
  description = "The subnet IDs"
  type        = list(string)
}

variable "ecs_lt_id" {
  description = "The launch template"
  type        = string
}
