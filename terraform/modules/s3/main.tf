# Bronze Bucket - Raw Data
resource "aws_s3_bucket" "bronze" {
  bucket = "${var.project_name}-bronze-${var.environment}"

  tags = {
    Name        = "Bronze Layer"
    Environment = var.environment
    Project     = var.project_name
    Layer       = "bronze"
  }
}

# Silver Bucket - Cleaned Data
resource "aws_s3_bucket" "silver" {
  bucket = "${var.project_name}-silver-${var.environment}"

  tags = {
    Name        = "Silver Layer"
    Environment = var.environment
    Project     = var.project_name
    Layer       = "silver"
  }
}

# Gold Bucket - Aggregated Data
resource "aws_s3_bucket" "gold" {
  bucket = "${var.project_name}-gold-${var.environment}"

  tags = {
    Name        = "Gold Layer"
    Environment = var.environment
    Project     = var.project_name
    Layer       = "gold"
  }
}

# Block public access - Bronze
resource "aws_s3_bucket_public_access_block" "bronze" {
  bucket                  = aws_s3_bucket.bronze.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access - Silver
resource "aws_s3_bucket_public_access_block" "silver" {
  bucket                  = aws_s3_bucket.silver.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access - Gold
resource "aws_s3_bucket_public_access_block" "gold" {
  bucket                  = aws_s3_bucket.gold.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}