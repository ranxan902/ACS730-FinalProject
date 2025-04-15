output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.project_public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.project_private[*].id
}
