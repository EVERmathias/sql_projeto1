# Projeto de SQL com análises baseadas nos salários, departamentos e anos de uma empresa  



### criando valores predefinidos para a coluna sexo
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


### 1. Importando a base de dados em formato txt para o banco de dados
```sql
COPY FUNCIONARIOS
FROM 'D:\exportados_postgre\funcionarios_localizacao2.csv'
DELIMITER ','
CSV HEADER;
```


### 2. Projetando as primeiras 25 linhas da tabela
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
<br/>


### 2. Quantas colunas o dataset possui?
```sql
select count(*) as contagem_colunas 
from information_schema.columns
where table_schema = 'public' 
and table_name = 'funcionarios';
```
<br/>


### 3. Quais são os tipos de dados de cada coluna?
```sql
select column_name as nome_coluna, 
	   data_type as formato_dado
from information_schema.columns
where table_schema = 'public'
and table_name = 'funcionarios';
```
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
<br/>



### 6. Qual a distribuição de funcionários por sexo?
```sql
select sexo,
	   count(*) as contagem
from funcionarios
group by sexo;
```
<br/>


### 7. Quantos departamentos diferentes existem?
```sql
select 
		distinct departamento
from funcionarios;
```
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
<br/>


### 9. Quantos funcionários trabalham no Brasil vs Canadá?
```sql
select
		pais,
		count(*)
from funcionarios
group by 1;
```
<br/>


### 10. Qual o salário médio geral?
```sql
select 
		round(avg(salario),2) as media_salario
from funcionarios;
```
<br/>


### 11. Qual o salário mínimo e máximo?
```sql
select 
		min(salario) as menor_salario,
		max(salario) as maior_salario
from funcionarios;
```
<br/>


### 12. Qual a mediana salarial?
```sql
select 
		round(median(salario),2) as mediana_salarial
from funcionarios;
```
<br/>


### 13. Qual o desvio padrão dos salários?
```sql
select
		round(stddev_pop(salario),2) as desvio_padrao
from funcionarios;
```
<br/>


## ANÁLISE TEMPORAL


### 14. 

