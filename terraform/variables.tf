variable "key_name" {
  description = "AWS key pair name for EC2"
  type        = string
  default     = "my-dast-key"   # your manually created AWS keypair
}

variable "instance_type" {
  default = "t3.micro"  # lowest-cost EC2
}

variable "aws_region" {
  default = "us-east-1"
}
