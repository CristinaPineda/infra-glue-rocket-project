resource "aws_s3_bucket" "script_bucket" {
  bucket = var.script_bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
data "aws_s3_bucket" "data_bucket" {
  bucket = var.data_bucket_name
}

data "aws_glue_catalog_database" "data_database" {
  name = "${var.project_name}-${var.environment}-db"
}

data "aws_glue_catalog_table" "data_table" {
  name          = "portos_data_catalog"
  database_name = data.aws_glue_catalog_database.data_database.name
}