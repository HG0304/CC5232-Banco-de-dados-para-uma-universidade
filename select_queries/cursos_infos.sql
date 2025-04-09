-- Todos os cursos (com nome do departamento e do coordenador):

SELECT 
    c.id, 
    c.nome AS nome_curso,
    d.nome AS nome_departamento,
    p.nome AS nome_coordenador
FROM Curso c
JOIN Departamento d ON c.departamento_id = d.id
LEFT JOIN Professor p ON c.coordenador_id = p.id;
