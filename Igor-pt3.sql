﻿/* Igor start */

/* Questao 1 */
CREATE VIEW vwProdutos AS
SELECT p.codigo, p.titulo, p.veiculo
FROM publicacao p
WHERE p.cod_projeto IN (SELECT codigo FROM projeto WHERE dt_inicio > '12/01/2012')

/* Questão 2 */

SELECT COUNT(*), cod_cnpq, cod_sub_cnpq
from aluno
where aluno.nivel = 'Mestrado'
GROUP BY cod_cnpq, cod_sub_cnpq;

/* Questao 3 */
CREATE VIEW vwQuest3 AS
SELECT l.codigo, l.nome , l.local
FROM laboratorio l
WHERE l.codigo IN (SELECT cod_laboratorio FROM laboratorio_projeto
                          WHERE cod_projeto IN (SELECT p.codigo FROM projeto p
                                                       WHERE EXTRACT(YEAR FROM p.dt_inicio) = 2005))

/* Questão 4 */

Select matricula, nivel, dt_nasc, ano
from aluno join aluno_publicacao on aluno.matricula = aluno_publicacao.mat_aluno join publicacao on aluno_publicacao.cod_publicacao = publicacao.codigo
where aluno.dt_nasc > '12/31/1990' and ano = 2012;


/* Questão 5 */
SELECT *
FROM projeto p
WHERE EXTRACT(YEAR FROM p.dt_inicio) > 2012 and orcamento < 800000

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
/* Questão 8 */

select nome from departamento 
where MAT_PROFESSOR 
not in(select p.matricula from professor p where  EXTRACT(YEAR FROM p.dt_nasc) = 1975 and p.matricula in
       (select MAT_PROFESSOR from aluno a where  nivel = 'doutorado'))


/* Questão 11 */

Select *
from aluno
where aluno.matricula in (SELECT aluno_publicacao.mat_aluno
    from aluno_publicacao
    where aluno_publicacao.cod_publicacao in (select codigo
    from publicacao
    where publicacao.ano = 2011)) and aluno.nivel = 'Doutorado';
/* Questão 12*/
 
select count(*) 
from aluno_publicacao
where mat_aluno in (select matricula from aluno where nivel <> 'mestrado')       
                                              
/* Questão 13 */

select SUM(orcamento)
from projeto
where dt_fim between '01/01/2009' and '12/31/2009';

/* Questão 14 */

Select nivel, nome
from aluno join aluno_publicacao on aluno.matricula = aluno_publicacao.mat_aluno join publicacao on publicacao.codigo = aluno_publicacao.cod_publicacao
where publicacao.ano > 2012;


/* Igor end */
