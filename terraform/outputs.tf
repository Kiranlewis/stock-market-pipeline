# terraform/outputs.tf

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
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
output "bronze_to_silver_job_name" {
  value = module.glue.bronze_to_silver_job_name
}
output "silver_to_gold_job_name" {
  value = module.glue.silver_to_gold_job_name
}
output "bronze_crawler_name" {
  value = module.glue.bronze_crawler_name
}
output "silver_crawler_name" {
  value = module.glue.silver_crawler_name
}
output "gold_crawler_name" {
  value = module.glue.gold_crawler_name
}