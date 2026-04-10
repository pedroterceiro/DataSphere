variable "subnet_cidrs" {
  type    = list(string)
  description = "Private and Public subnets CIDR"
  default = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20", "192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20"]
}

variable "public_subnet_az" {
  type = map(number)

  description = "Availability Zones for public subnets"

  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    "us-east-1c" = 3
  }
}

variable "private_subnet_az" {
  type = map(number)

  description = "Availability Zones for private subnets"

  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    "us-east-1c" = 3
  }
}