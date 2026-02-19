terraform {
  backend "s3" {
    bucket         = "dast-s3-123456789"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
