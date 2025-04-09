--Todos os TCCs (com nome do orientador):

SELECT 
    t.id,
    t.titulo,
    p.nome AS nome_orientador,
    t.ano
FROM TCC t
JOIN Professor p ON t.orientador_id = p.id;
