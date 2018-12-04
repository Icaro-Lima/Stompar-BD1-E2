-- 1. Crie uma view que lista as publicações geradas em projetos que iniciaram
-- em 2013.
CREATE OR replace VIEW vwprodutos
AS
  SELECT p.codigo,
         p.titulo,
         p.veiculo
  FROM   PUBLICACAO p
  WHERE  p.cod_projeto IN (SELECT codigo
                           FROM   PROJETO
                           WHERE  dt_inicio > '12/01/2012');                      


-- 2. Liste a quantidade de alunos de mestrado que possuem bolsa, por Linha de
-- Pesquisa.
SELECT COUNT(*),
       cod_cnpq,
       cod_sub_cnpq
FROM   ALUNO
WHERE  LOWER(ALUNO.nivel) = 'mestrado'
GROUP  BY cod_cnpq,
          cod_sub_cnpq;


-- 3. Crie uma view que lista os laboratórios que executam projetos iniciados
-- em 2005.
CREATE OR replace VIEW vwquest3
AS
  SELECT l.codigo,
         l.nome,
         l.local
  FROM   LABORATORIO l
  WHERE  l.codigo IN (SELECT cod_laboratorio
                      FROM   LABORATORIO_PROJETO
                      WHERE  cod_projeto IN (SELECT p.codigo
                                             FROM   PROJETO p
                                             WHERE  EXTRACT(
                                            year FROM p.dt_inicio)
                                                    = 2005
                                            ));


-- 4. Quais os alunos que de doutorado nasceram depois de 1990 e têm alguma
-- publicação no ano de 2012?
SELECT ALUNO.*
FROM   ALUNO aluno,
       PUBLICACAO pub,
       ALUNO_PUBLICACAO aluno_pub
WHERE  EXTRACT (year FROM ALUNO.dt_nasc) > 1990
       AND LOWER(ALUNO.nivel) = 'doutorado'
       AND aluno_pub.mat_aluno = ALUNO.matricula
       AND aluno_pub.cod_publicacao = pub.codigo
       AND pub.ano = 2012;


-- 5. Quais os projetos que iniciaram depois de 2012 e possuem um orçamento
-- menor que R$ 800.000?
SELECT *
FROM   PROJETO
WHERE  EXTRACT (year FROM dt_inicio) > 2012
       AND orcamento < 800000;


-- 6. Quais professores participam de todos os projetos?
SELECT prof.*
FROM   PROFESSOR prof
WHERE  (SELECT COUNT(*)
        FROM   PROFESSOR_PROJETO prof_proj
        WHERE  prof.matricula = prof_proj.mat_professor) = (SELECT COUNT(*)
                                                            FROM   PROJETO);


-- 7. Quais agências financiadoras que financiam bolsas de mais de R$2000 para
--alunos de doutorado?
SELECT agencia.*
FROM   ALUNO aluno,
       AGENCIA_FINANCIADORA agencia
WHERE  ALUNO.valor_bolsa > 2000
       AND LOWER(ALUNO.nivel) = 'doutorado'
       AND ALUNO.cod_agencia = agencia.codigo;


-- 8. Liste os departamentos que são gerenciados por professores que nasceram em
-- 1975 e não têm nenhum aluno de doutorado como orientando.
SELECT dept.*
FROM   DEPARTAMENTO dept,
       PROFESSOR prof
WHERE  dept.mat_professor = prof.matricula
       AND EXTRACT (year FROM prof.dt_nasc) = 1975
       AND prof.matricula NOT IN (SELECT mat_professor
                                  FROM   ALUNO
                                  WHERE  LOWER(nivel) = 'doutorado');


-- 9. Liste a quantidade de alunos de graduação financiados por agência
-- financiadora, exiba todos os dados da agência, inclua as agências que não
-- financiam nenhum aluno graduação.
SELECT (SELECT COUNT(*)
        FROM   ALUNO aluno
        WHERE  ALUNO.cod_agencia = agencia.codigo
               AND LOWER(ALUNO.nivel) = 'graduação') AS alunos_financiados,
       agencia.*
FROM   AGENCIA_FINANCIADORA agencia;


-- 10. Liste os departamentos por tamanho do orçamento dos projetos coordenados
-- pelos seus professores.
SELECT (SELECT SUM(proj.orcamento)
        FROM   PROJETO proj,
               PROFESSOR prof
        WHERE  proj.mat_professor = prof.matricula
               AND prof.matricula IN (SELECT mat_professor
                                      FROM   DEPARTAMENTO
                                      WHERE  codigo = dept.codigo)),
       dept.*
FROM   DEPARTAMENTO dept;


-- 11.Quais os alunos de doutorado que participaram de alguma publicação em
-- 2011?
SELECT *
FROM   ALUNO
WHERE  ALUNO.matricula IN (SELECT ALUNO_PUBLICACAO.mat_aluno
                           FROM   ALUNO_PUBLICACAO
                           WHERE  ALUNO_PUBLICACAO.cod_publicacao IN (SELECT
                                  codigo
                                                                      FROM
                                  PUBLICACAO
                                                                      WHERE
                                  PUBLICACAO.ano = 2011))
       AND LOWER(ALUNO.nivel) = 'doutorado';


-- 12.Liste a quantidade de publicações no ano de 2005 que não contam com a
-- participação nenhum aluno de mestrado.
SELECT COUNT(*)
FROM   PUBLICACAO
WHERE  PUBLICACAO.ano = 2005
       AND PUBLICACAO.codigo IN (SELECT cod_publicacao
                                 FROM   ALUNO_PUBLICACAO ap
                                 WHERE  ap.mat_aluno IN (SELECT matricula
                                                         FROM   ALUNO
                                                         WHERE
                                        LOWER(ALUNO.nivel) <> 'mestrado'));


-- 13.Qual a soma dos orçamentos dos projetos que encerraram em 2009.
SELECT SUM(orcamento)
FROM   PROJETO
WHERE  EXTRACT (year FROM dt_fim) = 2009;


-- 14.Liste o nível e o nome dos alunos que participaram de publicações depois
-- de 2012.
SELECT nivel,
       nome
FROM   ALUNO
       join ALUNO_PUBLICACAO
         ON ALUNO.matricula = ALUNO_PUBLICACAO.mat_aluno
       join PUBLICACAO
         ON PUBLICACAO.codigo = ALUNO_PUBLICACAO.cod_publicacao
WHERE  PUBLICACAO.ano > 2012;


-- 15. Crie um trigger para toda vez que uma nova patente for inserida,
-- incremente a coluna premiação (que deve ser colocada com valor ZERO para cada
-- projeto cadastrado) na tabela de projetos.
CREATE OR replace TRIGGER incr_premiacao_por_patente
  BEFORE INSERT ON PATENTE
  FOR EACH ROW
BEGIN
    UPDATE PROJETO
    SET    premiacao = premiacao + 1
    WHERE  codigo = :new.cod_projeto;
END;

/


-- 16. Crie um trigger que não permita a inserção de bolsas com valor menor que
-- R$ 430 para alunos de graduação e R$ 1000 para alunos de mestrado e
-- doutorado.
CREATE OR replace TRIGGER bolsa_restricoes
  BEFORE INSERT ON ALUNO
  FOR EACH ROW
BEGIN
    IF LOWER(:new.nivel) = 'graduação'
       AND :new.valor_bolsa < 430 THEN
      RAISE_APPLICATION_ERROR(-20001,
      'Aluno de graduação não pode possuir bolsa menor que R$ 430.');
    ELSIF ( LOWER(:new.nivel) = 'mestrado'
             OR LOWER(:new.nivel) = 'doutorado' )
          AND :new.valor_bolsa < 1000 THEN
      RAISE_APPLICATION_ERROR(-20002,
'Aluno de mestrado ou doutorado não pode possuir bolsa menor que R$ 1000.');
END IF;
END;

/
