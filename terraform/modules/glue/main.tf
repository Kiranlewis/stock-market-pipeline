# Glue Database - Data Catalog
resource "aws_glue_catalog_database" "main" {
  name        = "${var.project_name}_${var.environment}"
  description = "Stock market pipeline data catalog"
}

# S3 path for Glue scripts
resource "aws_s3_object" "bronze_to_silver_script" {
  bucket = var.scripts_bucket_name
  key    = "glue-scripts/bronze_to_silver.py"
  source = "${path.module}/../../../glue_jobs/bronze_to_silver.py"
  etag   = filemd5("${path.module}/../../../glue_jobs/bronze_to_silver.py")
}

resource "aws_s3_object" "silver_to_gold_script" {
  bucket = var.scripts_bucket_name
  key    = "glue-scripts/silver_to_gold.py"
  source = "${path.module}/../../../glue_jobs/silver_to_gold.py"
  etag   = filemd5("${path.module}/../../../glue_jobs/silver_to_gold.py")
}

# Glue Job 1 - Bronze to Silver
resource "aws_glue_job" "bronze_to_silver" {
  name         = "${var.project_name}-bronze-to-silver-${var.environment}"
  role_arn     = var.glue_role_arn
  glue_version = "4.0"
  worker_type  = "G.1X"
  number_of_workers = 2

  command {
    script_location = "s3://${var.scripts_bucket_name}/glue-scripts/bronze_to_silver.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"        = "python"
    "--job-bookmark-option" = "job-bookmark-enable"
    "--enable-metrics"      = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--bronze_bucket"       = var.bronze_bucket_name
    "--silver_bucket"       = var.silver_bucket_name
    "--database_name"       = aws_glue_catalog_database.main.name
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Layer       = "bronze-to-silver"
  }
}

# Glue Job 2 - Silver to Gold
resource "aws_glue_job" "silver_to_gold" {
  name         = "${var.project_name}-silver-to-gold-${var.environment}"
  role_arn     = var.glue_role_arn
  glue_version = "4.0"
  worker_type  = "G.1X"
  number_of_workers = 2

  command {
    script_location = "s3://${var.scripts_bucket_name}/glue-scripts/silver_to_gold.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"        = "python"
    "--job-bookmark-option" = "job-bookmark-enable"
    "--enable-metrics"      = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--silver_bucket"       = var.silver_bucket_name
    "--gold_bucket"         = var.gold_bucket_name
    "--database_name"       = aws_glue_catalog_database.main.name
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Layer       = "silver-to-gold"
  }
}

# Glue Crawler - Bronze
resource "aws_glue_crawler" "bronze" {
  name          = "${var.project_name}-bronze-crawler-${var.environment}"
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.main.name

  s3_target {
    path = "s3://${var.bronze_bucket_name}"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Glue Crawler - Silver
resource "aws_glue_crawler" "silver" {
  name          = "${var.project_name}-silver-crawler-${var.environment}"
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.main.name

  s3_target {
    path = "s3://${var.silver_bucket_name}"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Glue Crawler - Gold
resource "aws_glue_crawler" "gold" {
  name          = "${var.project_name}-gold-crawler-${var.environment}"
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.main.name

  s3_target {
    path = "s3://${var.gold_bucket_name}"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}