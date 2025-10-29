# Projeto de SQL com análises baseadas nos salários, departamentos e anos de uma empresa  



### Criando valores predefinidos para a coluna sexo
```sql
CREATE TYPE genero AS ENUM ('Masculino','Feminino');
```

### Criando a tabela funcionarios
```sql
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
```
<br/>

### Importando a base de dados em formato txt para o banco de dados
```sql
COPY FUNCIONARIOS
FROM 'D:\exportados_postgre\funcionarios_localizacao2.csv'
DELIMITER ','
CSV HEADER;
```


### Projetando as primeiras 25 linhas da tabela
```sql
select * 
from funcionarios 
limit 25;
```
<br/>


## PERGUNTAS E ANÁLISES BÁSICAS Exploração Inicial


### 1. Quantos funcionários existem no total?
```sql
select 
	count(*) as contagem_funcionarios
from funcionarios;
```
![Contagem funcionários total](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/1_contagem_funcionarios.png)

<br/>


### 2. Quantas colunas o dataset possui?
```sql
select count(*) as contagem_colunas 
from information_schema.columns
where table_schema = 'public' 
and table_name = 'funcionarios';
```
![Colunas no Dataset](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/2_contagem_colunas.png)
<br/>


### 3. Quais são os tipos de dados de cada coluna?
```sql
select column_name as nome_coluna, 
	   data_type as formato_dado
from information_schema.columns
where table_schema = 'public'
and table_name = 'funcionarios';
```
![Tipos em cada coluna](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/3_tipos_dados_coluna.png)

<br/>


### 4. Existem valores nulos ou duplicados?
```sql
select * from funcionarios
where nome is null
or sexo is null
or departamento is null
or data_admissao is null
or salario is null
or cargo is null 
or localizacao is null 
or pais is null;
```
![Nulos ou duplicados](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/4_verifica_valores_nulos.png)

<br/>


### 5. Qtde de valores distintos das variáveis
```sql
select 
	   count(distinct departamento) as departamentos_distintos,
	   count(distinct cargo) as cargos_distintos,
	   count(distinct localizacao) as localizacoes_distintas,
	   count(distinct pais) as paises_distintos
from funcionarios;
```
![Distintos das variáveis](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/5_conta_valores_distintos.png)

<br/>



### 6. Qual a distribuição de funcionários por sexo?
```sql
select sexo,
	   count(*) as contagem
from funcionarios
group by sexo;
```
![Distribuição por sexo](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/6_contagem_por_sexo.png)

<br/>


### 7. Quantos departamentos diferentes existem?
```sql
select 
		distinct departamento
from funcionarios;
```
![Departamentos distintos](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/7_contagem_departamentos.png)

<br/>


### 8. Qual departamento tem mais funcionários?
```sql
select 
		departamento, 
		count(*) as contagem
from funcionarios
group by departamento
order by 1
limit 1;
```
![Derpartamentos mais populoso](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/8_departamento_mais_populoso.png)
<br/>


### 9. Quantos funcionários trabalham no Brasil vs Canadá?
```sql
select
		pais,
		count(*)
from funcionarios
group by 1;
```
![BrasilvsCanada](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/9_contagem_brasil_vs_canada.png)

<br/>


### 10. Qual o salário médio geral?
```sql
select 
		round(avg(salario),2) as media_salario
from funcionarios;
```
![salario médio geral](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/10_salario_medio_geral.png)

<br/>


### 11. Qual o salário mínimo e máximo?
```sql
select 
		min(salario) as menor_salario,
		max(salario) as maior_salario
from funcionarios;
```
![Salario minimo e maximo](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/11_maior_e_menor_salario.png)

<br/>


### 12. Qual a mediana salarial?
```sql
select 
		round(median(salario),2) as mediana_salarial
from funcionarios;
```
![Mediana salarial](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/12_mediana_salarial.png)

<br/>


### 13. Qual o desvio padrão dos salários?
```sql
select
		round(stddev_pop(salario),2) as desvio_padrao
from funcionarios;
```
![Desvio padrao salarial](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/13_desvio_padrao.png)

<br/>


## ANÁLISE TEMPORAL


### 14. Qual a média de funcionários admitidos por mês?
```sql
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
```
![](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/14_media_funcionarios_admitos_mes.png)

<br/>



### 15. Qual ano teve mais contratações?
```sql
select 
		extract(year from data_admissao) as ano,
		count(*) as qtde_funcionarios
from funcionarios
group by ano
order by 2 desc
limit 1;
```
![](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/15_ano_maior_contratacao.png)

<br/>


### 16. Calcule o tempo médio de casa dos funcionários (em anos)
```sql
select	
		round(avg(((current_date - data_admissao)/365)),2) as media_anos
from funcionarios;
```
![](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/16_tempo_medio_funcionarios.png)

<br/>


### 17. Identifique os 10 funcionários mais antigos
```sql
select
		nome,
		data_admissao
from funcionarios
order by 2
limit 10;
```
![](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/17_os_10_funcionarios_mais_antigos.png)

<br/>


## ANÁLISE SALARIAL AVANÇADA

### 18. Qual o salário médio por departamento?
```sql
select 	
		departamento,
		round(avg(salario),2) as media_salarial
from funcionarios
group by departamento;
```
![](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/18_salario_medio_departamento.png)

<br/>


### 19. Quais os 5 cargos mais bem pagos?
```sql
select
		cargo,
		salario
from funcionarios
group by cargo, salario
order by 2 desc
limit 5;
```
![](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/19_cargos_mais_bem_pagos.png)

<br/>


### 20. Compare o salário médio entre homens e mulheres
```sql
select sexo,
		round(avg(salario),2) as media_salarial
from funcionarios
group by sexo;
```
![](https://github.com/EVERmathias/sql_projeto1/blob/main/projeto_imagens/20_comparacao_salario_hvsm.png)

<br/>

### 21. Existe diferença salarial significativa entre regiões?
```sql
select 
		pais,
		localizacao,
		sum(salario) as salario_total_departamento
from funcionarios
group by pais, localizacao
order by 3 desc;
```
<br/>

### ANÁLISE GEOGRÁFICA

### 22. Quantos funcionários por região (Brasil)?
```sql
select
		localizacao,
		pais,
		count(id) as qtde_funcionarios
from funcionarios
where pais = 'Brasil'
group by pais, localizacao
order by 3 desc;
```
<br/>

### 23. Quantos funcionários por província (Canadá)?
```sql
select
		localizacao,
		pais,
		count(id) as qtde_funcionarios
from funcionarios
where pais = 'Canada'
group by pais, localizacao
order by 3 desc;
```
<br/>


### 24. Qual região/província tem o maior salário médio?
```sql
select
		localizacao,
		pais,
		round(avg(salario),2) as salario_medio
from funcionarios
group by localizacao, pais
order by 3 desc;
```
<br/>


### 25. Distribua os funcionários por país e sexo
```sql
select	
		pais,
		sexo,
		count(id) as qtde_funcionarios
from funcionarios
group by sexo, pais
order by 1,3 desc;
```
<br/>


## ANÁLISE DE CARGOS 

### 26. Quantos cargos únicos existem?
```sql
select
		count(distinct cargo)
from funcionarios;
```
<br/>


### 27. Quais os 10 cargos mais comuns?
```sql
select	
		cargo,
		count(*) as qtde_funcionarios
from funcionarios
group by cargo
order by 2 desc
limit 10;
```
<br/>


### 28. Qual cargo tem o maior salário médio?
```sql
select
		cargo,
		round(avg(salario),2) as media_salario
from funcionarios
group by cargo
order by 2 desc
limit 1;
```
<br/>


### 29. Identifique cargos que aparecem em apenas um departamento
```sql
select	
		cargo
from funcionarios
group by cargo
having count(departamento) = 1;
```
<br/>


## ANÁLISE FILTROS E ORDENAÇÃO

### 30. Mostre todos os funcionários do Brasil.
```sql
select
		nome,
		cargo,
		pais
from funcionarios
where pais = 'Brasil';
```
<br/>


### 31. Liste os funcionários do departamento “Computadores” com salário acima de 70.000.
```sql
select 
		nome,
		departamento,
		salario
from funcionarios
where departamento = 'Computadores'
and salario > 70000;
```
<br/>


### 32. Exiba funcionários contratados após 2013.
```sql
select
		nome,
		cargo,
		data_admissao
from funcionarios
where data_admissao > '2013-01-01';
```
<br/>


### 33. Liste os 10 primeiros funcionários ordenados pelo salário do maior para o menor.
```sql
select
		nome,
		salario
from funcionarios
order by 2 desc;
```
<br/>


### 34. Mostre o nome, departamento e salário dos 5 funcionários mais bem pagos.
```sql
select
		nome,
		departamento,
		salario
from funcionarios
order by 3 desc
limit 5;
```
<br/>


## AGREGAÇÕES E AGRUPAMENTOS

### 35. Mostre quantos funcionários há em cada departamento, ordenando do maior para o menor número.
```sql
select
		departamento,
		count(*)
from funcionarios
group by departamento
order by 1;
```
<br/>


## CONDIÇÕES COM AGREGAÇÃO

### 36. Mostre apenas os departamentos com média salarial acima de 100.000.
```sql
select
		departamento,
		round(avg(salario),2)
from funcionarios
group by departamento
having avg(salario) > 100000;
```
<br/>


### 37. Liste os departamentos que possuem mais de 50 funcionários.
```sql
select
		departamento,
		count(id)
from funcionarios
group by departamento
having count(id) > 50;
```
<br/>


### 38. Exiba o salário médio por país e por departamento.
```sql
select
		pais,
		departamento,
		round(avg(salario),2) as salario_medio		
from funcionarios
group by pais, departamento
order by 1,3 desc;
```
<br/>


### 39. Liste o nome e salário do funcionário mais bem pago de cada departamento.
```sql
select 	
		f.nome,
		f.departamento,
		f.salario
from funcionarios as f
where salario = (select 
						max(salario)
				 from funcionarios
				 where departamento = f.departamento);
```
<br/>


### 40. Contagem de contração por ano.
```sql
select	
		extract(year from data_admissao) as ano,
		count(*) as contagem_funcionarios
from funcionarios
group by ano
order by 2 desc;
```
<br/>


### 41. Salário médio por cargo
```sql
select
		cargo,
		round(avg(salario),2) as salario_medio
from funcionarios
group by cargo;
```
