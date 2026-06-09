variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM role ARN for Lambda"
  type        = string
}

variable "bronze_bucket_name" {
  description = "Bronze bucket name"
  type        = string
}

variable "lambda_zip_path" {
    description = "Lambda zip path"
    type = string
}

variable "massive_api_key" {
  type = string
}
