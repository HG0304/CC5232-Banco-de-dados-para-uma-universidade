-- Recupera os nomes dos estudantes que cursaram disciplinas do departamento de "Matemática"

SELECT DISTINCT 
    a.id AS aluno_id, 
    a.nome AS nome_aluno
FROM HistoricoEscolar he
JOIN Aluno a ON he.aluno_id = a.id
JOIN Disciplina d ON he.disciplina_id = d.id
JOIN Departamento dep ON d.departamento_id = dep.id
WHERE dep.nome = 'Matemática';