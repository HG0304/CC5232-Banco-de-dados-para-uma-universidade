-- Encontra os estudantes que cursaram "Ciência da Computação" ou "Engenharia Elétrica"

SELECT 
    a.id AS aluno_id, 
    a.nome AS nome_aluno, 
    c.nome AS nome_curso
FROM Aluno a
JOIN Curso c ON a.curso_id = c.id
WHERE c.nome IN ('Ciência da Computação', 'Engenharia Elétrica');