import os
import random
from faker import Faker
import psycopg2
from dotenv import load_dotenv

# carrega as variaveis de ambiente
load_dotenv()

# cria a conexao com o banco
conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)
cur = conn.cursor()

# crio a instancia do faker
fake = Faker('pt_BR')

# seto as constantas de qnt de cada elemento da tabela (exeto tabelas hardcoded)
NUM_DEPARTAMENTOS = 5
NUM_PROFESSORES = 20
NUM_ALUNOS = 100
NUM_HISTORICO_ESCOLAR = 200
NUM_HISTORICO_LECIONADAS = 30


# 1. Departamento
departamento_ids = []
for _ in range(NUM_DEPARTAMENTOS):
    nome = f"Departamento de {fake.word().capitalize()}"
    cur.execute("INSERT INTO Departamento (nome) VALUES (%s) RETURNING id", (nome,))
    departamento_ids.append(cur.fetchone()[0])

# 2. Professor
professor_ids = []
for _ in range(NUM_PROFESSORES):
    nome = fake.name()
    dep_id = random.choice(departamento_ids)
    cur.execute("INSERT INTO Professor (nome, departamento_id) VALUES (%s, %s) RETURNING id", (nome, dep_id))
    professor_ids.append(cur.fetchone()[0])

# 3. Chefes de departamento
for dep_id in departamento_ids:
    chefe_id = random.choice(professor_ids)
    cur.execute("UPDATE Departamento SET chefe_id = %s WHERE id = %s", (chefe_id, dep_id))

# 4. Curso

# Os cursos usando somente o faker ficaram muito estranhos, tipo:
# - curso de padeiro
# - curso de retificador

# Então preferi deixar hardcoded com materias do nosso dia a dia mesmo. 
cursos_exatas = [
    "Engenharia da Computação", "Engenharia Elétrica", "Engenharia Mecânica",
    "Engenharia Civil", "Engenharia de Software", "Ciência da Computação",
    "Matemática", "Física", "Estatística", "Sistemas de Informação"
]
curso_ids = []
for nome in cursos_exatas:
    dep_id = random.choice(departamento_ids)
    cur.execute("INSERT INTO Curso (nome, departamento_id) VALUES (%s, %s) RETURNING id", (nome, dep_id))
    curso_ids.append(cur.fetchone()[0])


# 5. Coordenadores de curso
for curso_id in curso_ids:
    coordenador_id = random.choice(professor_ids)
    cur.execute("UPDATE Curso SET coordenador_id = %s WHERE id = %s", (coordenador_id, curso_id))

# 6. Aluno
aluno_ids = []
for _ in range(NUM_ALUNOS):
    nome = fake.name()
    curso_id = random.choice(curso_ids)
    cur.execute("INSERT INTO Aluno (nome, curso_id) VALUES (%s, %s) RETURNING id", (nome, curso_id))
    aluno_ids.append(cur.fetchone()[0])

# 7. Disciplina
# Deixei hardcoded pelo mesmo motivo dos cursos.
disciplinas_exatas = [
    "Cálculo I", "Cálculo II", "Álgebra Linear", "Geometria Analítica",
    "Física I", "Física II", "Programação I", "Programação II",
    "Estruturas de Dados", "Banco de Dados", "Sistemas Operacionais",
    "Redes de Computadores", "Eletricidade Básica", "Circuitos Elétricos",
    "Mecânica dos Sólidos"
]
disciplina_ids = []
for nome in disciplinas_exatas:
    codigo = fake.unique.bothify(text='###-???')
    departamento_id = random.choice(departamento_ids)
    cur.execute(
        "INSERT INTO Disciplina (codigo, nome, departamento_id) VALUES (%s, %s, %s) RETURNING id",
        (codigo, nome, departamento_id)
    )
    disciplina_ids.append(cur.fetchone()[0])

# 8. CursoDisciplina
for curso_id in curso_ids:
    disciplinas_para_curso = random.sample(disciplina_ids, k=random.randint(2, 5))
    for disc_id in disciplinas_para_curso:
        cur.execute("INSERT INTO CursoDisciplina (curso_id, disciplina_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
                    (curso_id, disc_id))

# 9. Histórico Escolar
for _ in range(NUM_HISTORICO_ESCOLAR):
    aluno_id = random.choice(aluno_ids)
    disciplina_id = random.choice(disciplina_ids)
    semestre = random.choice(["1", "2"])
    ano = random.randint(2018, 2024)
    nota = round(random.uniform(0, 10), 2)
    status = "Aprovado" if nota >= 6 else "Reprovado"
    cur.execute(
        """INSERT INTO HistoricoEscolar (aluno_id, disciplina_id, semestre, ano, nota, status)
           VALUES (%s, %s, %s, %s, %s, %s)""",
        (aluno_id, disciplina_id, semestre, ano, nota, status)
    )

# 10. Histórico de Lecionadas
for _ in range(NUM_HISTORICO_LECIONADAS):
    professor_id = random.choice(professor_ids)
    disciplina_id = random.choice(disciplina_ids)
    semestre = random.choice(["1", "2"])
    ano = random.randint(2018, 2024)
    cur.execute(
        """INSERT INTO HistoricoLecionadas (professor_id, disciplina_id, semestre, ano)
           VALUES (%s, %s, %s, %s)""",
        (professor_id, disciplina_id, semestre, ano)
    )

# 11. TCC
# mesma coisa das disciplinas e cursos
temas_tcc = [
    "Desenvolvimento de um sistema embarcado para controle de temperatura",
    "Análise de algoritmos de ordenação aplicados a grandes volumes de dados",
    "Estudo comparativo de bancos de dados relacionais e não-relacionais",
    "Simulação computacional de sistemas dinâmicos mecânicos",
    "Implementação de uma rede neural para classificação de imagens",
    "Otimização de rotas usando algoritmos genéticos",
    "Automatização residencial com Arduino e sensores IoT",
    "Avaliação de desempenho de microcontroladores em sistemas de tempo real",
    "Modelagem matemática de epidemias com equações diferenciais",
    "Projeto de um compilador simples para linguagem de domínio específico"
]
tcc_ids = []
for _ in range(len(temas_tcc)):
    titulo = random.choice(temas_tcc)
    orientador_id = random.choice(professor_ids)
    ano = random.randint(2020, 2024)
    cur.execute(
        "INSERT INTO TCC (titulo, orientador_id, ano) VALUES (%s, %s, %s) RETURNING id",
        (titulo, orientador_id, ano)
    )
    tcc_ids.append(cur.fetchone()[0])

# 12. GrupoTCC
for tcc_id in tcc_ids:
    grupo = random.sample(aluno_ids, k=random.randint(1, 3))
    for aluno_id in grupo:
        cur.execute(
            "INSERT INTO GrupoTCC (tcc_id, aluno_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
            (tcc_id, aluno_id)
        )

# insere os dados no banco 
conn.commit()
print("✅ Banco de dados populado com sucesso!")

# fecha a conexão
cur.close()
conn.close()
