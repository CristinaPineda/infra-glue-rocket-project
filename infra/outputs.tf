output "glue_catalog_database_name" {
  description = "The name of the Glue Catalog Database."
  value       = aws_glue_catalog_database.rocket_project_glue_database.name
}

output "glue_catalog_database_arn" {
  description = "The ARN of the Glue Catalog Database."
  value       = aws_glue_catalog_database.rocket_project_glue_database.arn
}

output "glue_job_name" {
  description = "The name of the Glue Job."
  value       = aws_glue_job.rocket_project_glue_job.name
}

output "glue_job_arn" {
  description = "The ARN of the Glue Job."
  value       = aws_glue_job.rocket_project_glue_job.arn
}