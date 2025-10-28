-- criando valores predefinidos para a coluna sexo
CREATE TYPE genero AS ENUM ('Masculino','Feminino');


-- Criando a tabela funcionarios
create table funcionarios(
			id int PRIMARY KEY NOT NULL,
			nome varchar(30),
			sexo genero,
			departamento varchar(30),
			data_admissao date,
			salario int,
			cargo varchar(40),
			localizacao varchar(20),
			pais varchar(20)	
);


-- 1. Importando a base de dados em formato txt para o banco de dados
COPY FUNCIONARIOS
FROM 'D:\exportados_postgre\funcionarios_localizacao2.csv'
DELIMITER ','
CSV HEADER;



-- 2. Projetando as primeiras 25 linhas da tabela
select * 
from funcionarios 
limit 25;





-- PERGUNTAS E ANÁLISES BÁSICAS Exploração Inicial

-- 1. Quantos funcionários existem no total?
select 
	count(*) as contagem_funcionarios
from funcionarios;


-- 2. Quantas colunas o dataset possui?
select count(*) as contagem_colunas 
from information_schema.columns
where table_schema = 'public' 
and table_name = 'funcionarios';

-- obs: no schema contém os metadados de dados as tabelas e colunas

-- 3. Quais são os tipos de dados de cada coluna?
select column_name as nome_coluna, 
	   data_type as formato_dado
from information_schema.columns
where table_schema = 'public'
and table_name = 'funcionarios';


-- 4. Existem valores nulos ou duplicados?
select * from funcionarios
where nome is null
or sexo is null
or departamento is null
or data_admissao is null
or salario is null
or cargo is null 
or localizacao is null 
or pais is null;


-- 5. Qtde de valores distintos das variáveis
select 
	   count(distinct departamento) as departamentos_distintos,
	   count(distinct cargo) as cargos_distintos,
	   count(distinct localizacao) as localizacoes_distintas,
	   count(distinct pais) as paises_distintos
from funcionarios;




-- ANÁLISE DE DISTRIBUIÇÃO

-- 6. Qual a distribuição de funcionários por sexo?
select sexo,
	   count(*) as contagem
from funcionarios
group by sexo;


-- 7. Quantos departamentos diferentes existem?
select 
		distinct departamento
from funcionarios;


-- 8. Qual departamento tem mais funcionários?
select 
		departamento, 
		count(*) as contagem
from funcionarios
group by departamento
order by 1
limit 1;

-- 9. Quantos funcionários trabalham no Brasil vs Canadá?
select
		pais,
		count(*)
from funcionarios
group by 1;




-- ESTATÍSTICAS SALARIAS BÁSICAS

-- 10. Qual o salário médio geral?
select 
		round(avg(salario),2) as media_salario
from funcionarios;


-- 11. Qual o salário mínimo e máximo?
select 
		min(salario) as menor_salario,
		max(salario) as maior_salario
from funcionarios;


-- 12. Qual a mediana salarial?
select 
		round(median(salario),2) as mediana_salarial
from funcionarios;


-- 13. Qual o desvio padrão dos salários?
select
		round(stddev_pop(salario),2) as desvio_padrao
from funcionarios;






-- ANÁLISE TEMPORAL

-- 14. Qual a média de funcionários admitidos por mes?
select	
		mes,
		round(avg(contagem),0) as media_contagem
from (select	
				extract(month from data_admissao) as mes,
				count(*) as contagem
		from funcionarios
		group by mes) as subconsulta
group by mes
order by 1;





-- 15. Qual ano teve mais contratações?
select 
		extract(year from data_admissao) as ano,
		count(*) as qtde_funcionarios
from funcionarios
group by ano
order by 2 desc
limit 1;



-- 16. Calcule o tempo médio de casa dos funcionários (em anos)
select	
		round(avg(((current_date - data_admissao)/365)),1) as media_anos
from funcionarios;


-- 17. Identifique os 10 funcionários mais antigos
select
		nome,
		data_admissao
from funcionarios
order by 2
limit 10;




-- ANÁLISE SALARIAL AVANÇADA

-- 18. Qual o salário médio por departamento?
select 	
		departamento,
		round(avg(salario),2) as media_salarial
from funcionarios
group by departamento;


-- 19. Quais os 5 cargos mais bem pagos?
select
		cargo,
		salario
from funcionarios
group by cargo, salario
order by 2 desc
limit 5;


-- 20. Compare o salário médio entre homens e mulheres
select sexo,
		round(avg(salario),2) as media_salarial
from funcionarios
group by sexo;



-- 21. Existe diferença salarial significativa entre regiões?
select 
		pais,
		localizacao,
		sum(salario) as salario_total_departamento
from funcionarios
group by pais, localizacao
order by 3 desc;





--  ANÁLISE GEOGRÁFICA

-- 22. Quantos funcionários por região (Brasil)?
select
		localizacao,
		pais,
		count(id) as qtde_funcionarios
from funcionarios
where pais = 'Brasil'
group by pais, localizacao
order by 3 desc;


-- 23. Quantos funcionários por província (Canadá)?
select
		localizacao,
		pais,
		count(id) as qtde_funcionarios
from funcionarios
where pais = 'Canada'
group by pais, localizacao
order by 3 desc;


-- 24. Qual região/província tem o maior salário médio?
select
		localizacao,
		pais,
		round(avg(salario),2) as salario_medio
from funcionarios
group by localizacao, pais
order by 3 desc;


-- 25. Distribua os funcionários por país e sexo
select	
		pais,
		sexo,
		count(id) as qtde_funcionarios
from funcionarios
group by sexo, pais
order by 1,3 desc;





-- ANÁLISE DE CARGOS 

-- 26. Quantos cargos únicos existem?
select
		count(distinct cargo)
from funcionarios;


-- 27. Quais os 10 cargos mais comuns?
select	
		cargo,
		count(*) as qtde_funcionarios
from funcionarios
group by cargo
order by 2 desc
limit 10;


-- 28. Qual cargo tem o maior salário médio?
select
		cargo,
		round(avg(salario),2) as media_salario
from funcionarios
group by cargo
order by 2 desc
limit 1;


-- 29. Identifique cargos que aparecem em apenas um departamento
select	
		cargo
from funcionarios
group by cargo
having count(departamento) = 1;




-- ANÁLISE FILTROS E ORDENAÇÃO

-- 30. Mostre todos os funcionários do Brasil.
select
		nome,
		cargo,
		pais
from funcionarios
where pais = 'Brasil';



-- 31. Liste os funcionários do departamento “Computadores” com salário acima de 70.000.
select 
		nome,
		departamento,
		salario
from funcionarios
where departamento = 'Computadores'
and salario > 70000;

-- 32. Exiba funcionários contratados após 2013.
select
		nome,
		cargo,
		data_admissao
from funcionarios
where data_admissao > '2013-01-01';


-- 33. Liste os 10 primeiros funcionários ordenados pelo salário do maior para o menor.
select
		nome,
		salario
from funcionarios
order by 2 desc
limit 10;

-- 34. Mostre o nome, departamento e salário dos 5 funcionários mais bem pagos.
select
		nome,
		departamento,
		salario
from funcionarios
order by 3 desc
limit 5;





-- AGREGAÇÕES E AGRUPAMENTOS



-- 35. Mostre quantos funcionários há em cada departamento, ordenando do maior para o menor número.
select
		departamento,
		count(*)
from funcionarios
group by departamento
order by 1;



-- CONDIÇÕES COM AGREGAÇÃO

-- 36. Mostre apenas os departamentos com média salarial acima de 100.000.
select
		departamento,
		round(avg(salario),2)
from funcionarios
group by departamento
having avg(salario) > 100000;


-- 37. Liste os departamentos que possuem mais de 50 funcionários.
select
		departamento,
		count(id)
from funcionarios
group by departamento
having count(id) > 50;



-- 38. Exiba o salário médio por país e por departamento (duplo agrupamento).
select
		pais,
		departamento,
		round(avg(salario),2) as salario_medio		
from funcionarios
group by pais, departamento
order by 1,3 desc;



-- 39. Liste o nome e salário do funcionário mais bem pago de cada departamento.
select 	
		f.nome,
		f.departamento,
		f.salario
from funcionarios as f
where salario = (select 
						max(salario)
				 from funcionarios
				 where departamento = f.departamento);




-- 40. Contagem de contração por ano.
select	
		extract(year from data_admissao) as ano,
		count(*) as contagem_funcionarios
from funcionarios
group by ano
order by 2 desc;




-- 41. Salário médio por cargo
select
		cargo,
		round(avg(salario),2) as salario_medio
from funcionarios
group by cargo;



-- FIM DAS ANÁLISES.
