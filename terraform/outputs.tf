output "iam_user_name" {
  value       = aws_iam_user.user.name
  description = "The name of the IAM user created for Docker S3 access."
}

output "iam_user_access_key_id" {
  value       = aws_iam_access_key.user_key.id
  description = "The Access Key ID for the IAM user."
  sensitive   = true
}

output "iam_user_secret_access_key" {
  value       = aws_iam_access_key.user_key.secret
  description = "The Secret Access Key for the IAM user."
  sensitive   = true
}
