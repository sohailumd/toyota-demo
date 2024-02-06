terraform {
  backend "s3" {
    bucket         = "s3-backend-tf-demo"
    key            = "RDS/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "demo-dynamodb-tf"
  }
}