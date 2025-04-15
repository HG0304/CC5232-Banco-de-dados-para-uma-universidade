SELECT
	a.nome, 
	a.id, 
	h.disciplina_id,
	d.nome
FROM aluno a 
INNER JOIN historicoescolar h ON a.id = h.aluno_id 
join disciplina d on h.disciplina_id = d.id 
WHERE h.disciplina_id = 17