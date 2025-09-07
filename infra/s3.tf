resource "aws_s3_bucket" "script_bucket" {
  bucket = var.script_bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = var.data_bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}