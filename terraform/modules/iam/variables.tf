variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "bronze_bucket_name" {
  description = "Bronze bucket name"
  type        = string
}

variable "silver_bucket_name" {
  description = "Silver bucket name"
  type        = string
}

variable "gold_bucket_name" {
  description = "Gold bucket name"
  type        = string
}