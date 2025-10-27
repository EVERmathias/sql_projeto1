# Projeto de SQL com análises baseadas nos salários, departamentos e anos de uma empresa  



-- criando valores predefinidos para a coluna sexo
```sql
CREATE TYPE genero AS ENUM ('Masculino','Feminino');
```

-- Criando a tabela funcionarios
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


-- 1. Importando a base de dados em formato txt para o banco de dados
```sql
COPY FUNCIONARIOS
FROM 'D:\exportados_postgre\funcionarios_localizacao2.csv'
DELIMITER ','
CSV HEADER;
```


-- 2. Projetando as primeiras 25 linhas da tabela
```sql
select * 
from funcionarios 
limit 25;
```
<br/>


-- PERGUNTAS E ANÁLISES BÁSICAS Exploração Inicial


-- 1. Quantos funcionários existem no total?
```sql
select 
	count(*) as contagem_funcionarios
from funcionarios;
```
<br/>


-- 2. Quantas colunas o dataset possui?
```sql
select count(*) as contagem_colunas 
from information_schema.columns
where table_schema = 'public' 
and table_name = 'funcionarios';
```
<br/>


-- 3. Quais são os tipos de dados de cada coluna?
```sql
select column_name as nome_coluna, 
	   data_type as formato_dado
from information_schema.columns
where table_schema = 'public'
and table_name = 'funcionarios';
```
<br/)
