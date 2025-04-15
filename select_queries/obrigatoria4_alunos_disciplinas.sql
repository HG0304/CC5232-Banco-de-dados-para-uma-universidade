-- Query para busacar alunos que esta-o cursando disciplinas
select 
	a.id as aluno_id
	, a.nome as nome_aluno
	, count(distinct disciplina_id) as qnt_disciplinas
from historicoescolar he
join aluno a on he.aluno_id = a.id
group by a.id, a.nome


-- Esta query retorna, para um aluno específico, os códigos e nomes das disciplinas já cursadas,
-- junto com os nomes dos professores que lecionaram cada disciplina para esse aluno,
-- além do nome do próprio aluno.

SELECT
    a.nome AS nome_aluno,
    d.codigo AS codigo_disciplina,
    d.nome AS nome_disciplina,
    p.nome AS nome_professor
FROM HistoricoEscolar he
JOIN Aluno a ON he.aluno_id = a.id
JOIN Disciplina d ON he.disciplina_id = d.id
JOIN HistoricoLecionadas hl
    ON hl.disciplina_id = he.disciplina_id
    AND hl.semestre = he.semestre
    AND hl.ano = he.ano
JOIN Professor p ON hl.professor_id = p.id

	-- -- Para buscar por um aluno especifico substitua aq
	-- Se quiser buscar por todos os aluno ao mesmo tempo basta deletar essa linha
	-- WHERE he.aluno_id = 112
ORDER BY d.nome, p.nome;
