# ------------------------
# Security Group
# ------------------------
resource "aws_security_group" "ssh_http" {
  name        = "ssh_http_sg"
  description = "Allow SSH and Juice Shop access"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # allow from anywhere

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]     # Juice Shop accessible for ZAP
  }

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
  ami           = "ami-0c2b8ca1dad447f8a"  # Amazon Linux 2023
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.ssh_http.name]

  tags = {
    Name = "DAST-EC2"
  }
}

# ------------------------
# S3 Bucket (TF state + DAST reports)
# ------------------------
resource "aws_s3_bucket" "dast_bucket" {
  bucket = "dast-s3-123456789"  # same bucket for state and reports
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "dast_report_placeholder" {
  bucket = aws_s3_bucket.dast_bucket.id
  key    = "dast-reports/.keep"  # optional placeholder folder
}

# # ------------------------
# # GitHub Secret: S3 Bucket
# # ------------------------
# resource "github_actions_secret" "dast_s3_bucket" {
#   repository      = var.github_repo_name
#   secret_name     = "DAST_S3_BUCKET"
#   plaintext_value = aws_s3_bucket.dast_bucket.bucket
# }

# # ------------------------
# # GitHub Secret: EC2 Public IP
# # ------------------------
# resource "github_actions_secret" "dast_ec2_ip" {
#   repository      = var.github_repo_name
#   secret_name     = "EC2_PUBLIC_IP"
#   plaintext_value = aws_instance.dast_ec2.public_ip
# }
