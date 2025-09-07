output "glue_job_name" {
  description = "The name of the Glue Job."
  value       = aws_glue_job.data_processing_job.name
}

output "glue_job_arn" {
  description = "The ARN of the Glue Job."
  value       = aws_glue_job.data_processing_job.arn
}