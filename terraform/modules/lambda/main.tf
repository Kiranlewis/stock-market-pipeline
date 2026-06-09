resource "aws_lambda_function" "stock_ingestion" {
    function_name = "${var.project_name}-stock-ingestion-${var.environment}"
    role = var.lambda_role_arn
    handler = "ingestion.lambda_handler.lambda_handler"
    runtime = "python3.11"
    filename = var.lambda_zip_path
    source_code_hash = filebase64sha256(var.lambda_zip_path)
    timeout = 60
    memory_size = 512
    environment {
      variables = {
        BUCKET_NAME = var.bronze_bucket_name
      }
    }
  
}