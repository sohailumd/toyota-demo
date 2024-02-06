output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.vpc_id
}

output "service-subnet" {
  value = aws_subnet.service-sn
}

output "database-subnet" {
  value = aws_subnet.database-sn
}

output "app-subnet" {
  value = aws_subnet.app-sn
}