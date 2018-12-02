
/* Questao 1 */
CREATE VIEW vwProdutos
AS
    SELECT p.codigo, p.titulo, p.veiculo
    FROM publicacao p
    WHERE p.cod_projeto IN (SELECT codigo
    FROM projeto
    WHERE dt_inicio > '12/01/2012')

/* Questão 2 */

SELECT COUNT(*), cod_cnpq, cod_sub_cnpq
from aluno
where LOWER(aluno.nivel) = 'mestrado'
GROUP BY cod_cnpq, cod_sub_cnpq;

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


/* Questão 8 */

select departamento.nome
from departamento join professor on departamento.mat_professor = matricula
where extract (year from dt_nasc) = 1975 and departamento.mat_professor not in (select mat_professor
    from aluno
    where mat_professor is not null);


/* Questão 11 */

Select *
from aluno
where aluno.matricula in (SELECT aluno_publicacao.mat_aluno
    from aluno_publicacao
    where aluno_publicacao.cod_publicacao in (select codigo
    from publicacao
    where publicacao.ano = 2011)) and LOWER(aluno.nivel) = 'doutorado';


/* Questão 12*/

select count(*)
from aluno_publicacao
where mat_aluno in (select matricula
from aluno
where LOWER(nivel) <> 'mestrado');

/* Questão 13 */

select SUM(orcamento)
from projeto
where dt_fim between '01/01/2009' and '12/31/2009';

/* Questão 14 */

Select nivel, nome
from aluno join aluno_publicacao on aluno.matricula = aluno_publicacao.mat_aluno join publicacao on publicacao.codigo = aluno_publicacao.cod_publicacao
where publicacao.ano > 2012;

