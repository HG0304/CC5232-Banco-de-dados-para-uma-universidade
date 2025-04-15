-- Query para descobrir em quantos cursos cada disciplina está presente
-- e mostrar o nome dos cursos

SELECT
    d.nome AS disciplina,
    COUNT(c.nome) AS qnt_cursos_com_a_disciplina,
    STRING_AGG(c.nome, ', ') AS cursos
FROM CursoDisciplina cd
JOIN Curso c ON c.id = cd.curso_id
JOIN Disciplina d ON d.id = cd.disciplina_id
GROUP BY d.nome
HAVING COUNT(c.nome) > 1
ORDER BY d.nome;

-- Grade curricular da eng. comp.
select
	c.nome as curso,
	d.nome as disciplina
from cursodisciplina cd
join curso c on c.id = cd.curso_id
join disciplina d on d.id = cd.disciplina_id
where c.nome = 'Engenharia da Computação';

-- Grade curricular de eng. sof.
select
	c.nome as curso,
	d.nome as disciplina
from cursodisciplina cd
join curso c on c.id = cd.curso_id
join disciplina d on d.id = cd.disciplina_id
where c.nome = 'Engenharia de Software';
