-- Lista os cursos que são ministrados pelo professor 'I001', juntamente com os títulos dos cursos

SELECT DISTINCT 
    c.id AS curso_id, 
    c.nome AS nome_curso
FROM Curso c
JOIN CursoDisciplina cd ON c.id = cd.curso_id
JOIN Disciplina d ON cd.disciplina_id = d.id
JOIN HistoricoLecionadas hl ON d.id = hl.disciplina_id
JOIN Professor p ON hl.professor_id = p.id
WHERE p.id = 1 -- Ajustado para o tipo SERIAL (inteiro)
  AND EXISTS (
      SELECT 1
      FROM HistoricoLecionadas hl2
      WHERE hl2.professor_id = p.id
        AND hl2.disciplina_id = d.id
  )
  AND hl.ano IS NOT NULL;