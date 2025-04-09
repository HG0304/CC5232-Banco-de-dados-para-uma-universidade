-- Seleciona qual o curso em que o aluno esta matriculado

SELECT 
    a.id, 
    a.nome AS nome_aluno, 
    c.nome AS nome_curso
FROM Aluno a
JOIN Curso c ON a.curso_id = c.id;
