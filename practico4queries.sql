select city.name as city_name, (
  select name
  from country
  where code = city.countrycode
) as country_name
from city
where city.countrycode in (
  select code
  from country
  where population < 10000
);

select name as city_name, population, (
  select avg(population) from city) as average
from city
where population > all (
  select avg(population)
  from city
)
order by population;


with asiatic_cities as (
  select id
  from city
  where countrycode in (
    select code
    from country
    where continent = "Asia"
  )
)
select city.name
from city
where city.population >= some (
  select population
  from city 
  where id in (select id from asiatic_cities)
)
and city.id not in (select id from asiatic_cities);


select (
  select country.name
  from country
  where code = cl_no.countrycode) as country_name,
cl_no.language as no_official_language, cl_no.percentage as no_official_percentage
from countrylanguage as cl_no
where cl_no.isofficial = "F" and cl_no.percentage > (
  select max(percentage)
  from countrylanguage as cl_o
  where cl_o.isofficial = "T"
  and cl_o.countrycode = cl_no.countrycode
) order by cl_no.percentage;


select region
from country
where surfacearea < 1000 and country.code in (
  select countrycode
  from city
  where population > 100000
)
group by region;

-- agregacion y consultas escalares
select country.name as country_name, (
  select max(population)
  from city
  where city.countrycode = country.code
) as max_city_population
from country
order by max_city_population;

-- agrupacion  
-- select country.name as country_name
-- from 


select (
  select country.name
  from country
  where code = cl_no.countrycode) as country_name,
cl_no.language as no_official_language, cl_no.percentage as no_official_percentage
from countrylanguage as cl_no
where cl_no.isofficial = "F" and cl_no.percentage > (
  select avg(percentage)
  from countrylanguage as cl_o
  where cl_o.isofficial = "T"
  and cl_o.countrycode = cl_no.countrycode
) order by cl_no.percentage;

select continent, sum(population) as population
from country
group by continent
order by population desc;

select continent, avg(lifeexpectancy) as lifeexpectancy 
from country
where lifeexpectancy between 40 and 70
group by continent;

with cp as (
  select continent, sum(population) as suma
  from country
  group by continent
)
select sum(cp.suma) as suma_total, avg(cp.suma) average,
min(cp.suma) as minimo, max(cp.suma) as maximo
from cp;




