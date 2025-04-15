-- Encontra os departamentos que oferecem cursos ministrados pelo professor 'I001'

SELECT DISTINCT 
    dep.id AS departamento_id, 
    dep.nome AS nome_departamento
FROM Departamento dep
JOIN Curso c ON dep.id = c.departamento_id
JOIN CursoDisciplina cd ON c.id = cd.curso_id
JOIN Disciplina d ON cd.disciplina_id = d.id
JOIN HistoricoLecionadas hl ON d.id = hl.disciplina_id
JOIN Professor p ON hl.professor_id = p.id
WHERE p.id = 'I001';