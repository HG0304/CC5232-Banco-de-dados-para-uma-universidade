-- Todos os grupos de TCC (alunos + título do TCC)

SELECT 
    gt.tcc_id,
    t.titulo AS titulo_tcc,
    a.id AS aluno_id,
    a.nome AS nome_aluno
FROM GrupoTCC gt
JOIN TCC t ON gt.tcc_id = t.id
JOIN Aluno a ON gt.aluno_id = a.id;
