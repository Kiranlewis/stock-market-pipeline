# terraform/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
}
module "iam" {
  source             = "./modules/iam"
  project_name       = var.project_name
  environment        = var.environment
  bronze_bucket_name = module.s3.bronze_bucket_name
  silver_bucket_name = module.s3.silver_bucket_name
  gold_bucket_name   = module.s3.gold_bucket_name
}
module "glue" {
  source              = "./modules/glue"
  project_name        = var.project_name
  environment         = var.environment
  glue_role_arn       = module.iam.glue_role_arn
  bronze_bucket_name  = module.s3.bronze_bucket_name
  silver_bucket_name  = module.s3.silver_bucket_name
  gold_bucket_name    = module.s3.gold_bucket_name
  scripts_bucket_name = module.s3.bronze_bucket_name
}