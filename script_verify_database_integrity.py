import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

"""
Funcionamento do script:

- Pega todos os arqiuvos que terminam com .sql da pasta select_queries.
- Executas todas as queries individualmente
- Se retornou algum resultado diferentem de NONE passa no teste
- Caso contrario a tabela não foi alimentada corretamente
"""

conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)

cursor = conn.cursor()

QUERY_FOLDER = "select_queries"
sql_files = [f for f in os.listdir(QUERY_FOLDER) if f.endswith('.sql')]

print(f"Encontradas {len(sql_files)} queries.")

for file in sql_files:
    path = os.path.join(QUERY_FOLDER, file)
    with open(path, "r", encoding="utf-8") as f:
        query = f.read()

    try:
        cursor.execute(query)
        result = cursor.fetchall()

        if result:
            print(f"[PASSOU ✅] {file}")
        else:
            print(f"[FALHOU ❌] {file} - retorno vazio")
    except Exception as e:
        print(f"[ERRO ❗] {file} - {e}")

cursor.close()
conn.close()
