-- Todo o histórico escolar 


SELECT 
    he.id,
    a.nome AS nome_aluno,
    d.nome AS nome_disciplina,
    he.semestre,
    he.ano,
    he.nota,
    he.status
FROM HistoricoEscolar he
JOIN Aluno a ON he.aluno_id = a.id
JOIN Disciplina d ON he.disciplina_id = d.id;
