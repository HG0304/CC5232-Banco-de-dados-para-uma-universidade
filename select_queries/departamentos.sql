-- Todos os departamentos (com nome do chefe):

SELECT 
    d.id, 
    d.nome AS nome_departamento,
    p.nome AS nome_chefe
FROM Departamento d
LEFT JOIN Professor p ON d.chefe_id = p.id;
