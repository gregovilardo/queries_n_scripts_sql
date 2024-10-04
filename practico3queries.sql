select city.Name, country.name, country.Region, country.GovernmentForm
from city
inner join country on city.CountryCode = country.Code
order by city.Population desc limit 10;

select country.Name,country.Population, city.*
from country
left join city on country.Capital = city.ID
order by country.Population limit 10;

select country.name, country.continent, countrylanguage.language
from country
right join countrylanguage on countrylanguage.countrycode = country.code
where countrylanguage.isofficial = "t"

select country.name, city.name
from country
inner join city on city.ID = country.Capital
order by surfacearea desc limit 20;

select city.name, countrylanguage.language, countrylanguage.percentage
from city
inner join country on city.countrycode = country.code
inner join countrylanguage on countrylanguage.countrycode = country.code
where countrylanguage.isofficial = "t"
order by city.Population desc;

(
  select country.name, country.population
  from country
  order by country.population desc limit 10
)
union
(
  select country.name, country.population
  from country
  where country.population >= 100
  order by country.population asc limit 10
);

select country.name, cs.language
from country
inner join countrylanguage as cs on cs.countrycode = country.code
where cs.isofficial = "T" and (cs.language = "French" OR cs.language = "English");

(
  select country.name
  from country
  inner join countrylanguage as cs on cs.countrycode = country.code
  where cs.language = "English"
)
except
(
  select country.name
  from country
  inner join countrylanguage as cs on cs.countrycode = country.code
  where cs.language = "Spanish"
);
