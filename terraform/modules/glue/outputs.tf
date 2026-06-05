output "bronze_to_silver_job_name" {
  description = "Bronze to Silver Glue job name"
  value       = aws_glue_job.bronze_to_silver.name
}

output "silver_to_gold_job_name" {
  description = "Silver to Gold Glue job name"
  value       = aws_glue_job.silver_to_gold.name
}

output "glue_database_name" {
  description = "Glue catalog database name"
  value       = aws_glue_catalog_database.main.name
}

output "bronze_crawler_name" {
  description = "Bronze crawler name"
  value       = aws_glue_crawler.bronze.name
}

output "silver_crawler_name" {
  description = "Silver crawler name"
  value       = aws_glue_crawler.silver.name
}

output "gold_crawler_name" {
  description = "Gold crawler name"
  value       = aws_glue_crawler.gold.name
}