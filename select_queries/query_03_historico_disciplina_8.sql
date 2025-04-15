SELECT nome, a.id, disciplina_id 

FROM aluno a 
INNER JOIN historicoescolar h 
 ON a.id = h.aluno_id 
WHERE h.disciplina_id = 8