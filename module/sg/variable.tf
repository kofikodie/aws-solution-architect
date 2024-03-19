variable "sg_egress" {
  type = map(object({
    name        = string
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "outbound" = {
      name        = "outbound"
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "ip_address" {
  description = "The IP address to allow SSH access from"
  type        = list(string)
}
