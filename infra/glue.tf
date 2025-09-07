# Arquivo: glue.tf (no repositório do Glue)

# Recurso do job AWS Glue
resource "aws_glue_job" "data_processing_job" {
  name     = "${var.project_name}-${var.environment}-processing-job"
  role_arn = var.glue_execution_role_arn
  
  # A linguagem e o caminho para o seu script
  command {
    script_location = "s3://${var.script_bucket_name}/scripts/glue_job_script.py"
    python_version  = "3"
  }
  
  # Aqui definimos os argumentos que o job aceita.
  # Note que os valores são apenas placeholders. A Lambda vai passar os valores reais.
  default_arguments = {
    "--job-language" = "python"
    "--enable-metrics" = "true"
    "--enable-glue-metrics" = "true"
    "--extra-py-files" = "s3://${var.script_bucket_name}/dependencies/pyspark_aws.zip"
    "--enable-continuous-logging" = "true"
    "--job-bookmark-option" = "job_bookmark_disable"
    "--custom-args" = "{\"ano\":\"\",\"mes\":\"\",\"dia\":\"\",\"tabela_origem\":\"\"}"
  }
  
  # Define o tipo de job
  worker_type = "G.1X"
  number_of_workers = 1
  
  # Define o tempo máximo de execução em minutos.
  timeout = 5 # 5 minutos
  
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}