-- Essa query retorna todos os TCCs orientados por cada professor,
-- mostrando o título do TCC, o nome do professor orientador, o ano do TCC
-- e o nome de cada aluno participante do projeto.
--
-- Ela faz isso unindo as tabelas TCC, Professor, GrupoTCC e Aluno:
-- 1. TCC é unido a Professor para obter o nome do orientador.
-- 2. TCC é unido a GrupoTCC para obter os alunos de cada TCC.
-- 3. GrupoTCC é unido a Aluno para obter o nome dos alunos.
-- O resultado mostra uma linha para cada aluno em cada TCC.

SELECT
    tcc.id AS tcc_id,
    tcc.titulo AS titulo_tcc,
    tcc.ano AS ano_tcc,
    p.nome AS nome_orientador,
    a.nome AS nome_aluno
FROM TCC tcc
JOIN Professor p ON tcc.orientador_id = p.id
JOIN GrupoTCC gtcc ON tcc.id = gtcc.tcc_id
JOIN Aluno a ON gtcc.aluno_id = a.id

-- Para buscar por um professor especifico substitua aq
-- Se quiser buscar por todos os professores ao mesmo tempo basta deletar essa linha
-- WHERE p.nome = 'Srta. Valentina da Mata' 

ORDER BY tcc.id, a.nome;
