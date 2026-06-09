# terraform/variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "stock-market-pipeline"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
variable "massive_api_key" {
  type      = string
  sensitive = true
}