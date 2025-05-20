
import os
import random
from faker import Faker
import psycopg2
from dotenv import load_dotenv
from datetime import date

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

# Definindo constantes
NUM_CLIENTES = 20
NUM_PRESTADORES = 15
NUM_SOLICITACOES = 50
NUM_EVIDENCIAS = 30
NUM_PAGAMENTOS = 40
NUM_AVALIACOES = 30
NUM_ESPECIALIDADES = 8
# Especialidades Hardcoded
especialidades = ["Eletricista", "Encanador", "Jardineiro", "Pedreiro", "Pintor", "Mecânico", "Babá", "Cozinheiro"]

# Funções auxiliares (se necessário, adapte-as com base no código de verificação)
def gerar_valor_decimal():
    return round(random.uniform(10.0, 1000.0), 2)

def gerar_data_aleatoria(start_year=2023):
    year = random.randint(start_year, 2025)
    month = random.randint(1, 12)
    day = random.randint(1, 28)  # Para evitar problemas com meses de 31 dias e fevereiro
    return date(year, month, day)

# 1. Inserir Clientes
cliente_ids = []
for _ in range(NUM_CLIENTES):
    nome = fake.name()
    email = fake.email()
    telefone = fake.phone_number()
    cur.execute("INSERT INTO Cliente (nome, email, telefone) VALUES (%s, %s, %s) RETURNING id", (nome, email, telefone))
    cliente_ids.append(cur.fetchone()[0])

# 2. Inserir Prestadores
prestador_ids = []
for _ in range(NUM_PRESTADORES):
    nome = fake.name()
    email = fake.email()
    telefone = fake.phone_number()
    cur.execute("INSERT INTO Prestador (nome, email, telefone) VALUES (%s, %s, %s) RETURNING id", (nome, email, telefone))
    prestador_ids.append(cur.fetchone()[0])

# 3. Inserir Especialidades (Hardcoded)
especialidade_ids = []
for especialidade in especialidades:
    cur.execute("INSERT INTO Especialidade (nome) VALUES (%s) RETURNING id", (especialidade,))
    especialidade_ids.append(cur.fetchone()[0])

# 4. Inserir Prestador_especialidade
for prestador_id in prestador_ids:
    # Escolhe um número aleatório de especialidades para cada prestador
    num_especialidades = random.randint(1, 3)
    especialidades_para_prestador = random.sample(especialidade_ids, num_especialidades)
    
    for especialidade_id in especialidades_para_prestador:
        cur.execute("INSERT INTO Prestador_especialidade (id_prestador, id_especialidade) VALUES (%s, %s)", (prestador_id, especialidade_id))

# 5. Inserir Solicitações
solicitacao_ids = []
for _ in range(NUM_SOLICITACOES):
    id_cliente = random.choice(cliente_ids)
    id_prestador = random.choice(prestador_ids)
    descricao = fake.text()
    valor = gerar_valor_decimal()
    data_criacao = gerar_data_aleatoria()
    status = random.choice(["Aberta", "Em Andamento", "Concluída", "Cancelada"])
    cur.execute(
        "INSERT INTO Solicitacao (id_cliente, id_prestador, descricao, valor, data_criacao, status) VALUES (%s, %s, %s, %s, %s, %s) RETURNING id",
        (id_cliente, id_prestador, descricao, valor, data_criacao, status)
    )
    solicitacao_ids.append(cur.fetchone()[0])

# 6. Inserir Evidências
for _ in range(NUM_EVIDENCIAS):
    id_solicitacao = random.choice(solicitacao_ids)
    descricao = fake.text()
    data_envio = gerar_data_aleatoria()
    foto = "imagem_exemplo.jpg"  # TODO:  Pode gerar nomes de arquivos fake se precisar
    cur.execute(
        "INSERT INTO evidencia (id_solicitacao, descricao, data_envio, foto) VALUES (%s, %s, %s, %s) RETURNING id",
        (id_solicitacao, descricao, data_envio, foto)
    )

# 7. Inserir Pagamentos
for _ in range(NUM_PAGAMENTOS):
    id_solicitacao = random.choice(solicitacao_ids)
    valor = gerar_valor_decimal()
    status = random.choice(["Pendente", "Pago", "Reembolsado"])
    data_pagamento = gerar_data_aleatoria()
    cur.execute(
        "INSERT INTO pagamento (id_solicitacao, valor, status, data_pagamento) VALUES (%s, %s, %s, %s) RETURNING id",
        (id_solicitacao, valor, status, data_pagamento)
    )

# 8. Inserir Avaliações
for _ in range(NUM_AVALIACOES):
    id_cliente = random.choice(cliente_ids)
    id_prestador = random.choice(prestador_ids)
    qtd_estrelas = str(random.randint(1, 5))  # Avaliação de 1 a 5 estrelas
    comentario = fake.text()
    data_avaliacao = gerar_data_aleatoria()
    cur.execute(
        "INSERT INTO Avalicao (id_cliente, id_prestador, qtd_estrelas, comentario, data_avaliacao) VALUES (%s, %s, %s, %s, %s) RETURNING id",
        (id_cliente, id_prestador, qtd_estrelas, comentario, data_avaliacao)
    )

# Finaliza a transação
conn.commit()
print("✅ Dados inseridos com sucesso!")

# fecha a conexão
cur.close()
conn.close()


