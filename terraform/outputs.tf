output "dast_ec2_public_ip" {
  value = aws_instance.dast_ec2.public_ip
}

output "dast_bucket_name" {
  value = aws_s3_bucket.dast_bucket.bucket
}
