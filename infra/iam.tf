resource "aws_iam_role" "glue_execution_role" {
  name = "${var.project_name}-${var.environment}-glue-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "glue_service_policy_attachment" {
  role       = aws_iam_role.glue_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_policy" "glue_custom_policy" {
  name = "${var.project_name}-${var.environment}-glue-custom-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          # Permissões para ler e escrever no S3
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.data_bucket_name}",
          "arn:aws:s3:::${var.data_bucket_name}/*",
          "arn:aws:s3:::${var.script_bucket_name}",
          "arn:aws:s3:::${var.script_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          # Permissões para o Glue Data Catalog
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:CreatePartition",
          "glue:BatchCreatePartition",
          "glue:UpdatePartition",
          "glue:DeletePartition"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          # Permissões para o CloudWatch Logs
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:AssociateLogStream",
          "logs:GetLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_custom_policy_attachment" {
  role       = aws_iam_role.glue_execution_role.name
  policy_arn = aws_iam_policy.glue_custom_policy.arn
}

output "glue_execution_role_arn" {
  description = "The ARN of the IAM role for Glue job execution."
  value       = aws_iam_role.glue_execution_role.arn
}