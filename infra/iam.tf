# 1. Cria a IAM Role de Execução do Glue
# Esta role é quem o serviço Glue irá assumir para executar o seu job.
resource "aws_iam_role" "glue_execution_role" {
  name = "${var.project_name}-${var.environment}-glue-execution-role"

  # Define a política de confiança, permitindo que o serviço Glue
  # possa assumir esta role.
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

# 2. Anexa a política gerenciada padrão do Glue à role
# Esta política concede permissões básicas para o serviço Glue rodar.
resource "aws_iam_role_policy_attachment" "glue_service_policy_attachment" {
  role       = aws_iam_role.glue_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# 3. Cria uma política personalizada com permissões específicas
# Esta política concede acesso ao S3 e ao Glue Data Catalog.
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

# 4. Anexa a política personalizada à role do Glue
resource "aws_iam_role_policy_attachment" "glue_custom_policy_attachment" {
  role       = aws_iam_role.glue_execution_role.name
  policy_arn = aws_iam_policy.glue_custom_policy.arn
}

# 5. Define a saída do ARN da role para ser usado em outros lugares
output "glue_execution_role_arn" {
  description = "The ARN of the IAM role for Glue job execution."
  value       = aws_iam_role.glue_execution_role.arn
}