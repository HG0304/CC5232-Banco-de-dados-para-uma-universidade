-- Encontra os estudantes que cursaram "Sistemas de Banco de Dados" mas não "Inteligência Artificial"

SELECT DISTINCT 
    he1.aluno_id, 
    a.nome AS nome_aluno
FROM HistoricoEscolar he1
JOIN Aluno a ON he1.aluno_id = a.id
JOIN Disciplina d1 ON he1.disciplina_id = d1.id
WHERE d1.nome = 'Sistemas de Banco de Dados'
  AND NOT EXISTS (
      SELECT 1
      FROM HistoricoEscolar he2
      JOIN Disciplina d2 ON he2.disciplina_id = d2.id
      WHERE he2.aluno_id = he1.aluno_id
        AND d2.nome = 'Inteligência Artificial'
  );