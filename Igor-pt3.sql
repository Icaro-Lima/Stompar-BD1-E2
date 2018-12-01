/* Igor start */

/* Questão 2 */

SELECT COUNT(*), cod_cnpq, cod_sub_cnpq
from aluno
where aluno.nivel = 'Mestrado'
GROUP BY cod_cnpq, cod_sub_cnpq;

/* Questão 4 */

Select matricula, nivel, dt_nasc, ano
from aluno join aluno_publicacao on aluno.matricula = aluno_publicacao.mat_aluno join publicacao on aluno_publicacao.cod_publicacao = publicacao.codigo
where aluno.dt_nasc > '12/31/1990' and ano = 2012;


/* Questão 5 */
SELECT *
FROM projeto
WHERE dt_inicio > '01/01/2012' AND orcamento < 800000;

/* Questão 6 */

Select matricula
from professor
where matricula = all (select mat_professor
from projeto);

/* Questão 7 */

Select *
from agencia_financiadora
where codigo in (select cod_agencia
from aluno
where nivel = 'Doutorado' and valor_bolsa > 2000);


/* Questão 11 */

Select *
from aluno
where aluno.matricula in (SELECT aluno_publicacao.mat_aluno
    from aluno_publicacao
    where aluno_publicacao.cod_publicacao in (select codigo
    from publicacao
    where publicacao.ano = 2011)) and aluno.nivel = 'Doutorado';

/* Questão 13 */

select SUM(orcamento)
from projeto
where dt_fim between '01/01/2009' and '12/31/2009';

/* Questão 14 */

Select nivel, nome
from aluno join aluno_publicacao on aluno.matricula = aluno_publicacao.mat_aluno join publicacao on publicacao.codigo = aluno_publicacao.cod_publicacao
where publicacao.ano > 2012;


/* Igor end */