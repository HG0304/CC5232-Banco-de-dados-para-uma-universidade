-- Retorna os professores chefes de cada departamento, e em caso de -none- preenche como nenhum

SELECT 
    p.nome AS nome_professor_chefe,
    CASE 
        WHEN d.nome IS NULL THEN 'nenhum'
        ELSE d.nome
    END AS departamento_que_coordena,
    CASE 
        WHEN c.nome IS NULL THEN 'nenhum'
        ELSE c.nome
    END AS curso_que_coordena
FROM Professor p
LEFT JOIN Departamento d ON d.chefe_id = p.id
LEFT JOIN Curso c ON c.coordenador_id = p.id;
