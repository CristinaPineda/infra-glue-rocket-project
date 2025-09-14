resource "aws_glue_job" "data_processing_job" {
  name     = "${var.project_name}-${var.environment}-processing-job"
  role_arn = var.glue_execution_role_arn
  
  command {
    script_location = "s3://${var.script_bucket_name}/scripts/glue_job_script.py"
    python_version  = "3"
  }
  
  default_arguments = {
    "--job-language" = "python"
    "--enable-metrics" = "true"
    "--enable-glue-metrics" = "true"
    "--extra-py-files" = "s3://${var.script_bucket_name}/dependencies/pyspark_aws.zip"
    "--enable-continuous-logging" = "true"
    "--job-bookmark-option" = "job_bookmark_disable"
    "--custom-args" = "{\"ano\":\"\",\"mes\":\"\",\"dia\":\"\",\"tabela_origem\":\"\"}"
  }
  
  worker_type = "G.1X"
  number_of_workers = 2
  
  timeout = 5 # 5 minutos
  
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}