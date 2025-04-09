-- Informações sobre as disciplinas

SELECT 
    d.id, 
    d.codigo,
    d.nome AS nome_disciplina,
    dep.nome AS nome_departamento
FROM Disciplina d
JOIN Departamento dep ON d.departamento_id = dep.id;
