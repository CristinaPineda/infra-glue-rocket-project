# Arquivo: glue_job_script.py

import sys
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import *

# Importa o módulo com sua lógica de transformação
from dataprep_portos import transform_data

# 1. Recebe os argumentos da função Lambda
args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'ano',
    'mes',
    'dia',
    'database_name_input',  # Nome do banco de dados de entrada
    'table_name_input',     # Nome da tabela de entrada
    'data_bucket_name_output' # Nome do bucket de saída
])

# 2. Inicializa o contexto do Glue
sc = SparkContext()
glueContext = GlueContext(sc)
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# 3. Lê os dados da partição
# AQUI ESTÁ A CORREÇÃO: Usamos o banco de dados e a tabela de entrada
datasource = glueContext.create_dynamic_frame.from_catalog(
    database=args['database_name_input'],
    table_name=args['table_name_input'],
    transformation_ctx="datasource",
    push_down_predicate=f"ano='{args['ano']}' and mes='{args['mes']}' and dia='{args['dia']}'"
)

# 4. Chama a função de transformação de seu arquivo separado
processed_data = transform_data(datasource)

# 5. Salva os dados processados em um novo local no S3
glueContext.write_dynamic_frame.from_options(
    frame=processed_data,
    connection_type="s3",
    connection_options={
        # O nome do bucket é agora dinâmico
        "path": f"s3://{args['data_bucket_name_output']}/spec_portos/",
        "partitionKeys": ["ano", "mes", "dia"]
    },
    format="parquet",
    transformation_ctx="datasink"
)

job.commit()
print("Job Glue concluído com sucesso!")