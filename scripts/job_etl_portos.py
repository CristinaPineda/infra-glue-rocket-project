# Arquivo: glue_job_script.py

import sys
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import *

# Importa o módulo com sua lógica de transformação
from dataprep_portos import transform_data

try:
    # 1. Recebe os argumentos da função Lambda
    args = getResolvedOptions(sys.argv, [
        'JOB_NAME',
        'ano',
        'mes',
        'dia',
        'data_bucket_name_output'
    ])
    
    # Validação dos argumentos
    required_args = ['ano', 'mes', 'dia', 'data_bucket_name_output']
    for arg in required_args:
        if arg not in args:
            raise ValueError(f"Argumento obrigatório não encontrado: '{arg}'")

    # 2. Inicializa o contexto do Glue
    sc = SparkContext()
    glueContext = GlueContext(sc)
    job = Job(glueContext)
    job.init(args['JOB_NAME'], args)

    database_name_input = 'rocket_project'
    table_name_input = 'sot_portos'
    
    # 3. Lê os dados da partição
    print(f"Lendo dados da partição: ano={args['ano']}, mes={args['mes']}, dia={args['dia']}")
    datasource = glueContext.create_dynamic_frame.from_catalog(
        database=database_name_input,
        table_name=table_name_input,
        transformation_ctx="datasource",
        push_down_predicate=f"ano='{args['ano']}' and mes='{args['mes']}' and dia='{args['dia']}'"
    )

    if datasource.count() == 0:
        print("Nenhum registro encontrado para a partição. Job finalizado.")
        job.commit()
        sys.exit(0) # Termina o job sem erro se não houver dados

    # 4. Chama a função de transformação de seu arquivo separado
    print(f"Número de registros para processar: {datasource.count()}")
    processed_data = transform_data(datasource)

    # 5. Salva os dados processados em um novo local no S3
    print("Salvando dados processados...")
    glueContext.write_dynamic_frame.from_options(
        frame=processed_data,
        connection_type="s3",
        connection_options={
            "path": f"s3://{args['data_bucket_name_output']}/spec_portos/",
            "partitionKeys": ["ano", "mes", "dia"]
        },
        format="parquet",
        transformation_ctx="datasink"
    )

    job.commit()
    print("Job Glue concluído com sucesso!")

except Exception as e:
    print(f"ERRO CRÍTICO: O job Glue falhou.")
    print(f"Detalhes do erro: {e}")
    # O `raise` garante que o job falhe e mostre a mensagem de erro nos logs do Glue
    raise e