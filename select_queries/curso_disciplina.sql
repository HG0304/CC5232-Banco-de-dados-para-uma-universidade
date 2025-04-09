-- Todas as relações curso-disciplina (com nomes):

SELECT 
    cd.curso_id, 
    c.nome AS nome_curso,
    cd.disciplina_id, 
    d.nome AS nome_disciplina
FROM CursoDisciplina cd
JOIN Curso c ON cd.curso_id = c.id
JOIN Disciplina d ON cd.disciplina_id = d.id;
