-- Todos os professores (com nome do departamento)

SELECT 
    p.id, 
    p.nome AS nome_professor,
    d.nome AS nome_departamento
FROM Professor p
JOIN Departamento d ON p.departamento_id = d.id;
