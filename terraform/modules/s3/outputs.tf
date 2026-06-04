output "bronze_bucket_name" {
  description = "Bronze bucket name"
  value       = aws_s3_bucket.bronze.bucket
}

output "silver_bucket_name" {
  description = "Silver bucket name"
  value       = aws_s3_bucket.silver.bucket
}

output "gold_bucket_name" {
  description = "Gold bucket name"
  value       = aws_s3_bucket.gold.bucket
}