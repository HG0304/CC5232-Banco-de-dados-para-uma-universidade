SELECT COUNT(DISTINCT h.aluno_id) AS Alunos, disciplina_id 

FROM historicoescolar h 
WHERE h.disciplina_id = 8 
GROUP BY h.disciplina_id