output "bronze_bucket_name" {
  description = "Bronze bucket name"
  value       = module.s3.bronze_bucket_name
}

output "silver_bucket_name" {
  description = "Silver bucket name"
  value       = module.s3.silver_bucket_name
}

output "gold_bucket_name" {
  description = "Gold bucket name"
  value       = module.s3.gold_bucket_name
}

output "lambda_role_arn" {
  description = "Lambda IAM role ARN"
  value       = module.iam.lambda_role_arn
}

output "glue_role_arn" {
  description = "Glue IAM role ARN"
  value       = module.iam.glue_role_arn
}