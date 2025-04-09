-- Lista os professores de cada disciplina

SELECT 
    hl.id,
    p.nome AS nome_professor,
    d.nome AS nome_disciplina,
    hl.semestre,
    hl.ano
FROM HistoricoLecionadas hl
JOIN Professor p ON hl.professor_id = p.id
JOIN Disciplina d ON hl.disciplina_id = d.id;
