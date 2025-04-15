-- Esta query retorna todos os alunos que foram reprovados em alguma disciplina,
-- e, caso exista, se o mesmo aluno foi aprovado em outro semestre na mesma disciplina.
--
-- Como funciona:
-- 1. Seleciona todos os registros de reprovação no histórico escolar (status = 'Reprovado').
-- 2. Para cada reprovação, faz um LEFT JOIN buscando uma aprovação (status = 'Aprovado')
--    do mesmo aluno na mesma disciplina, mas em semestre ou ano diferente.
-- 3. Se o aluno tiver sido aprovado em outro semestre/ano, os dados dessa aprovação
--    aparecerão nas colunas correspondentes; caso contrário, essas colunas ficarão nulas.
-- 4. Assim, é possível visualizar tanto as reprovações quanto se o aluno conseguiu
--    aprovação posteriormente (ou anteriormente) na mesma disciplina.


SELECT 
    a.id AS aluno_id,
    a.nome AS nome_aluno,
    d.codigo AS codigo_disciplina,
    d.nome AS nome_disciplina,
    he.semestre AS semestre_reprovado,
    he.ano AS ano_reprovado,
    he.nota AS nota_reprovado,
    he.status AS status_reprovado,
    he_aprovado.semestre AS semestre_aprovado,
    he_aprovado.ano AS ano_aprovado,
    he_aprovado.nota AS nota_aprovado,
    he_aprovado.status AS status_aprovado
FROM Aluno a
JOIN HistoricoEscolar he 
    ON a.id = he.aluno_id
JOIN Disciplina d 
    ON he.disciplina_id = d.id
LEFT JOIN HistoricoEscolar he_aprovado
    ON he_aprovado.aluno_id = he.aluno_id
    AND he_aprovado.disciplina_id = he.disciplina_id
    AND he_aprovado.status = 'Aprovado'
    AND (he_aprovado.semestre <> he.semestre OR he_aprovado.ano <> he.ano)
WHERE he.status = 'Reprovado'
	
	-- Para buscar por um aluno especifico substitua aq
	-- Se quiser buscar por todos os alunos ao mesmo tempo basta deletar essa linha
    -- AND a.nome = 'Srta. Bianca Ribeiro'

order by a.nome, he_aprovado.semestre
