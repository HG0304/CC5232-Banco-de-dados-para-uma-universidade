-- Criação das tabelas em ordem lógica de dependências

BEGIN;

-- Tabela base: Departamento (não depende de nenhuma outra)
CREATE TABLE Departamento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Curso depende de Departamento
CREATE TABLE Curso (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    departamento_id INT NOT NULL REFERENCES Departamento(id) ON DELETE CASCADE
);

-- Professor depende de Departamento
CREATE TABLE Professor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    departamento_id INT NOT NULL REFERENCES Departamento(id) ON DELETE CASCADE
);

-- Atualiza Departamento para adicionar relação com Professor (chefe)
ALTER TABLE Departamento
ADD COLUMN chefe_id INT REFERENCES Professor(id) ON DELETE SET NULL;

-- Atualiza Curso para adicionar coordenador (Professor)
ALTER TABLE Curso
ADD COLUMN coordenador_id INT REFERENCES Professor(id) ON DELETE SET NULL;

-- Aluno depende de Curso
CREATE TABLE Aluno (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    curso_id INT NOT NULL REFERENCES Curso(id) ON DELETE CASCADE
);

-- Disciplina depende de Departamento
CREATE TABLE Disciplina (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    departamento_id INT NOT NULL REFERENCES Departamento(id) ON DELETE CASCADE
);

-- Tabela de relacionamento Curso-Disciplina
CREATE TABLE CursoDisciplina (
    curso_id INT NOT NULL REFERENCES Curso(id) ON DELETE CASCADE,
    disciplina_id INT NOT NULL REFERENCES Disciplina(id) ON DELETE CASCADE,
    PRIMARY KEY (curso_id, disciplina_id)
);

-- Histórico Escolar depende de Aluno e Disciplina
CREATE TABLE HistoricoEscolar (
    id SERIAL PRIMARY KEY,
    aluno_id INT NOT NULL REFERENCES Aluno(id) ON DELETE CASCADE,
    disciplina_id INT NOT NULL REFERENCES Disciplina(id) ON DELETE CASCADE,
    semestre VARCHAR(10) NOT NULL,
    ano INT NOT NULL,
    nota DECIMAL(5,2),
    status VARCHAR(50) NOT NULL CHECK (status IN ('Aprovado', 'Reprovado'))
);

-- Histórico de Lecionadas depende de Professor e Disciplina
CREATE TABLE HistoricoLecionadas (
    id SERIAL PRIMARY KEY,
    professor_id INT NOT NULL REFERENCES Professor(id) ON DELETE CASCADE,
    disciplina_id INT NOT NULL REFERENCES Disciplina(id) ON DELETE CASCADE,
    semestre VARCHAR(10) NOT NULL,
    ano INT NOT NULL
);

-- TCC depende de Professor
CREATE TABLE TCC (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    orientador_id INT NOT NULL REFERENCES Professor(id) ON DELETE CASCADE,
    ano INT NOT NULL
);

-- Relacionamento TCC-Aluno
CREATE TABLE GrupoTCC (
    tcc_id INT NOT NULL REFERENCES TCC(id) ON DELETE CASCADE,
    aluno_id INT NOT NULL REFERENCES Aluno(id) ON DELETE CASCADE,
    PRIMARY KEY (tcc_id, aluno_id)
);

COMMIT;