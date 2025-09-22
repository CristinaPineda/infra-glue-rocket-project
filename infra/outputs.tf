output "glue_job_name" {
  description = "The name of the Glue Job."
  value       = aws_glue_job.data_processing_job.name
}
output "glue_job_arn" {
  description = "The ARN of the Glue Job."
  value       = aws_glue_job.data_processing_job.arn
}
output "database_name" {
  description = "The name of the Glue Catalog database."
  value       = data.aws_glue_catalog_database.data_database.name
}
output "table_name" {
  description = "The name of the Glue Catalog table."
  value       = data.aws_glue_catalog_table.data_table.name
}