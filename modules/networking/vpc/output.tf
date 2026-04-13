output "private_subnets" {
  value = values(aws_subnet.private)[*].id
}

output "public_subnets" {
  value = values(aws_subnet.public)[*].id
}
