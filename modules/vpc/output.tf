output "vpc_id" {
  value = aws_vpc.default.id
}

output "vpc_public_subnets" {
  value = aws_subnet.public.*.id
}

output "vpc_private_subnets" {
  value = aws_subnet.private.*.id
}

output "lambda_subnets" {
  value = aws_subnet.private.*.id
}

output "vpc_private_rt" {
  value = aws_route_table.main.id
}

output "vpc_public_rt" {
  value = aws_route_table.custom.id
}
