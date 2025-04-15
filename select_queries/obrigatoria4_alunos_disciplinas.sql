select 
	a.nome as nome_aluno
	, d.nome as nome_disciplina
	, he.semestre as semestre
	, he.ano as ano
	, STRING_AGG(p.nome, ', ') AS nome_professores
from historicoescolar he
join aluno a on he.aluno_id = a.id
join disciplina d on he.disciplina_id  = d.id	
left join historicolecionadas hr on he.disciplina_id  = hr.disciplina_id
left join professor p on hr.professor_id = p.id

	-- Para buscar por um aluno especifico substitua aq
	-- Se quiser buscar por todos os alunos ao mesmo tempo basta deletar essa linha
    where a.nome = 'Arthur Gabriel Machado'

group by a.nome, d.nome, he.semestre, he.ano
order by a.nome, d.nome
