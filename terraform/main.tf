# ------------------------
# Security Group
# ------------------------
resource "aws_security_group" "ssh_http" {
  name        = "ssh_http_sg"
  description = "Allow SSH and Juice Shop access"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # allow from anywhere so that Ansible can config it
  }

  # Juice Shop (Port 3000)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Juice Shop accessible for ZAP
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------------------------
# EC2 Instance
# ------------------------
resource "aws_instance" "dast_ec2" {
  ami             = "ami-0c2b8ca1dad447f8a"  # Amazon Linux 2023
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.ssh_http.name]

  tags = {
    Name = "DAST-EC2"
  }
}

# ------------------------
# S3 Bucket (TF state + DAST reports)
# ------------------------
resource "aws_s3_bucket" "dast_bucket" {
  bucket = "dast-s3-123456789"  # must be globally unique
}

# Enable versioning (new syntax for AWS provider v5+)
resource "aws_s3_bucket_versioning" "dast_bucket_versioning" {
  bucket = aws_s3_bucket.dast_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Optional placeholder object
resource "aws_s3_object" "dast_report_placeholder" {
  bucket = aws_s3_bucket.dast_bucket.id
  key    = "dast-reports/.keep"
  content = ""
}
