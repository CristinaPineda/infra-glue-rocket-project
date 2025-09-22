variable "project_name" {
  description = "The name of the project. Used for tagging resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (dev, prod, etc.)."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy the resources."
  type        = string
  default     = "sa-east-1"
}
variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable glue_execution_role_arn {
  description = "The ARN of the IAM role that AWS Glue will assume to run the job."
  type        = string
}

variable "script_bucket_name" {
  description = "The name of the S3 bucket where the Glue job scripts are stored."
  type        = string
}

variable "data_bucket_name" {
  description = "The name of the S3 bucket where the data is stored."
  type        = string  
}