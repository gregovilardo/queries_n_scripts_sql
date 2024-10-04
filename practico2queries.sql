select name, Region from country order by name;

select name, Population from country order by Population DESC limit 10; 

select name, Region, SurfaceArea, GovernmentForm from country order by SurfaceArea limit 10; 

select name from country where IndepYear is null;

select Language, Percentage from countrylanguage where IsOfficial = 'T';

update countrylanguage set Percentage = 100.0 where Language = 'English' and CountryCode = 'AIA';

select name from city where District = 'CÃ³rdoba' and CountryCode = (select Code from country where Name = 'Argentina');

delete from city where District = 'CÃ³rdoba' and CountyCode != (select Code from country where Name = 'Argentina');

select name from country where HeadOfState like 'John%';

select name, Population from country where Population between 35000000 and 45000000 order by Population;

