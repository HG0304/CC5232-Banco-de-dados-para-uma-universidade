SELECT nome
FROM Ppfessor
WHERE id IN (
    SELECT professor_id
    FROM historicolecionadas
    WHERE disciplina_id IN (
        SELECT disciplina_id
        FROM cursodisciplina
        WHERE curso_id IN (18, 27)
    )
);
