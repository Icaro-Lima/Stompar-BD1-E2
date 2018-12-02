﻿
/* Questao 1 */
CREATE VIEW vwProdutos
AS
    SELECT p.codigo, p.titulo, p.veiculo
    FROM publicacao p
    WHERE p.cod_projeto IN (SELECT codigo
    FROM projeto
    WHERE dt_inicio > '12/01/2012')

/* Questão 2 */

SELECT Count(*),
       cod_cnpq,
       cod_sub_cnpq
FROM   aluno
WHERE  Lower(aluno.nivel) = 'mestrado'
GROUP  BY cod_cnpq,
          cod_sub_cnpq; 

/* Questao 3 */
CREATE VIEW vwQuest3
AS
    SELECT l.codigo, l.nome , l.local
    FROM laboratorio l
    WHERE l.codigo IN (SELECT cod_laboratorio
    FROM laboratorio_projeto
    WHERE cod_projeto IN (SELECT p.codigo
    FROM projeto p
    WHERE EXTRACT(YEAR FROM p.dt_inicio) = 2005))

-- 4. Quais os alunos que de doutorado nasceram depois de 1990 e têm alguma
-- publicação no ano de 2012?
SELECT aluno.*
FROM   aluno aluno,
       publicacao pub,
       aluno_publicacao aluno_pub
WHERE  Extract (year FROM aluno.dt_nasc) > 1990
       AND Lower(aluno.nivel) = 'doutorado'
       AND aluno_pub.mat_aluno = aluno.matricula
       AND aluno_pub.cod_publicacao = pub.codigo
       AND pub.ano = 2012;

-- 5. Quais os projetos que iniciaram depois de 2012 e possuem um orçamento
-- menor que R$ 800.000?
SELECT *
FROM   projeto
WHERE  Extract (year FROM dt_inicio) > 2012
       AND orcamento < 800000;

-- 6. Quais professores participam de todos os projetos?
SELECT prof.*
FROM   professor prof
WHERE  (SELECT Count(*)
        FROM   professor_projeto prof_proj
        WHERE  prof.matricula = prof_proj.mat_professor) = (SELECT Count(*)
                                                            FROM   projeto);

-- 7. Quais agências financiadoras que financiam bolsas de mais de R$2000 para
--alunos de doutorado?
SELECT agencia.*
FROM   aluno aluno,
       agencia_financiadora agencia
WHERE  aluno.valor_bolsa > 2000
       AND Lower(aluno.nivel) = 'doutorado'
       AND aluno.cod_agencia = agencia.codigo;


-- 8. Liste os departamentos que são gerenciados por professores que nasceram em
-- 1975 e não têm nenhum aluno de doutorado como orientando.
SELECT dept.*
FROM   departamento dept,
       professor prof
WHERE  dept.mat_professor = prof.matricula
       AND Extract (year FROM prof.dt_nasc) = 1975
       AND prof.matricula NOT IN (SELECT mat_professor
                                  FROM   aluno
                                  WHERE  Lower(nivel) = 'doutorado');

-- 9. Liste a quantidade de alunos de graduação financiados por agência
-- financiadora, exiba todos os dados da agência, inclua as agências que não
-- financiam nenhum aluno graduação.
SELECT (SELECT Count(*)
        FROM   aluno aluno
        WHERE  aluno.cod_agencia = agencia.codigo
               AND Lower(aluno.nivel) = 'graduação') AS alunos_financiados,
       agencia.*
FROM   agencia_financiadora agencia;

-- 10. Liste os departamentos por tamanho do orçamento dos projetos coordenados
-- pelos seus professores.
SELECT (SELECT Sum(proj.orcamento)
        FROM   projeto proj,
               professor prof
        WHERE  proj.mat_professor = prof.matricula
               AND prof.matricula IN (SELECT mat_professor
                                      FROM   departamento
                                      WHERE  codigo = dept.codigo)),
       dept.*
FROM   departamento dept;
			  
/* Questão 11 */

SELECT *
FROM   aluno
WHERE  aluno.matricula IN (SELECT aluno_publicacao.mat_aluno
                           FROM   aluno_publicacao
                           WHERE  aluno_publicacao.cod_publicacao IN (SELECT
                                  codigo
                                                                      FROM
                                  publicacao
                                                                      WHERE
                                  publicacao.ano = 2011))
       AND Lower(aluno.nivel) = 'doutorado'; 


	   
-- 12.Liste a quantidade de publicações no ano de 2005 que não contam com a participação
-- nenhum aluno de mestrado.
SELECT Count(*)
FROM publicacao
WHERE publicacao.ano = 2005 AND publicacao.codigo IN (SELECT cod_publicacao 
													  FROM aluno_publicacao ap 
													  WHERE ap.mat_aluno IN (SELECT matricula 
																			 FROM aluno 
																			 WHERE LOWER(aluno.NIVEL) <> 'mestrado'));

/* Questão 13 */

SELECT SUM(orcamento)
FROM   projeto
WHERE  dt_fim BETWEEN '01/01/2009' AND '12/31/2009'; 

/* Questão 14 */

SELECT nivel,
       nome
FROM   aluno
       join aluno_publicacao
         ON aluno.matricula = aluno_publicacao.mat_aluno
       join publicacao
         ON publicacao.codigo = aluno_publicacao.cod_publicacao
WHERE  publicacao.ano > 2012; 

