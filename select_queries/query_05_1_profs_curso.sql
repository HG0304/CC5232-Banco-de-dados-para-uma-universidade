SELECT DISTINCT p.nome AS professor, c.nome AS curso

FROM professor p
INNER JOIN historicoLecionadas h ON p.id = h.professor_id
INNER JOIN cursoDisciplina cd ON cd.disciplina_id = h.disciplina_id
INNER JOIN curso c ON c.id = cd.curso_id
WHERE c.id IN (18, 27);
