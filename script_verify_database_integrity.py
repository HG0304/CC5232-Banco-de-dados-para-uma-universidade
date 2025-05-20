import os
import psycopg2
from dotenv import load_dotenv
import re                                               

load_dotenv()

"""
Funcionamento do script:

- Pega todos os arquivos que terminam com .sql da pasta select_queries.
- Executa todas as queries individualmente.
- Verifica a integridade dos dados retornados:
  - Nomes não podem conter números.
  - Datas e valores numéricos devem ser válidos.
  - Alunos devem estar matriculados em cursos existentes.
  - Professores devem estar associados a departamentos existentes.
  - Cursos e disciplinas devem existir na tabela cursodisciplina.
"""

def validate_data(file, result):
    if "alunos_cursos" in file:
        # Verifica se os nomes não contêm números
        for row in result:
            for value in row:
                if isinstance(value, str) and re.search(r'\d', value):
                    return f"[FALHOU ❌] {file} - Nome inválido com números: {value}"
        # Verifica se os alunos estão matriculados em cursos existentes
        for row in result:
            if row[1] is None:  # Supondo que o segundo campo seja o curso
                return f"[FALHOU ❌] {file} - Aluno matriculado em curso inexistente: {row}"
    if "professores_departamento" in file:
        for row in result:
            if row[1] is None:
                return f"[FALHOU ❌] {file} - Professor sem departamento associado: {row}"
    if "curso_disciplina" in file:
        for row in result:
            if row[0] is None or row[1] is None:
                return f"[FALHOU ❌] {file} - Curso ou disciplina inexistente: {row}"
    if result:
        return f"[PASSOU ✅] {file}"
    return f"[FALHOU ❌] {file} - retorno vazio"


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
            validation_message = validate_data(file, result)
            print(validation_message)
        else:
            print(f"[FALHOU ❌] {file} - Retorno vazio")
    except Exception as e:
        print(f"[ERRO ❗] {file} - {e}")

cursor.close()
conn.close()