output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "service-subnet" {
  description = "Service Subnet"
  value = aws_subnet.service-sn.id
}

output "database-subnet" {
  description = "Database Subnet"
  value = aws_subnet.database-sn.id
}

output "app-subnet" {
  description = "App Subnet"
  value = aws_subnet.app-sn.id
}