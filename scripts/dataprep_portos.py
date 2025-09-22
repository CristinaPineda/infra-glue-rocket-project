# Arquivo: transformations.py

from awsglue.transforms import *

def transform_data(dynamic_frame):
    """
    Aplica as transformações necessárias nos dados de entrada.
    
    Args:
        dynamic_frame: O DynamicFrame do Glue com os dados brutos.

    Returns:
        Um novo DynamicFrame com os dados transformados.
    """
    print("Iniciando a transformação dos dados...")

    
    
    # Exemplo: mapeia as colunas para o esquema final
    transformed_frame = ApplyMapping.apply(
        frame=dynamic_frame, 
        mappings=[
            ("nome_porto", "string", "nome_porto", "string"),
            # Adicione aqui todos os outros mapeamentos de colunas
            ("cnpj", "string", "cnpj_transformado", "string") # Exemplo de coluna transformada
        ]
    )
    
    print("Transformação concluída com sucesso!")
    return transformed_frame