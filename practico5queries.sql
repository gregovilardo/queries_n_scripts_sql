select * from actor where actor_id in (
select actor_id
from film_actor 
group by actor_id 
order by count(actor_id) desc) limit 5;

insert into directors (directorId, nombre, apellido, numberOfMovies)
select actor.actor_id,
actor.first_name,
actor.last_name, 
count(actor.actor_id) as cnt 
from actor
left join film_actor
on actor.actor_id = film_actor.actor_id
group by actor.actor_id
order by cnt desc
limit 5
;

alter table customer
add premium_customer enum("T","F") default 'F'
;

update customer
join 
(select customer.customer_id as cid, customer.first_name, sum(payment.amount)
from customer
left join payment on customer.customer_id = payment.customer_id
group by cid
limit 10) as top_customers
on customer.customer_id = top_customers.cid
set premium_customer = "T"
;

select rating, count(rating) as cnt from film group by rating order by cnt desc;

(select payment_date from payment order by payment_date asc limit 1)
union all
(select payment_date from payment order by payment_date desc limit 1)
;

select extract(month from payment_date) as month from payment group by month;


select extract(month from payment_date) as month, avg(amount)
from payment
group by month;

select extract(month from payment_date) as month, 
(select count(payment_id) from payment)/count(payment_id)
from payment
group by month;

Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total de alquileres).


select count(rental_id), district from rental
join staff on staff.staff_id = rental.staff_id  
join address on staff.address_id = address.address_id
group by district
;

-- Modifique la table `inventory_id` agregando una columna `stock` que sea un número entero y representa la cantidad de copias de una misma película que tiene determinada tienda. El número por defecto debería ser 5 copias.

alter table inventory add stock int default 5;

-- Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la tabla rental, haga un update en la tabla `inventory` restando una copia al stock de la película rentada (Hint: revisar que el rental no tiene información directa sobre la tienda, sino sobre el cliente, que está asociado a una tienda en particular).

delimiter //

drop trigger if exists update_stock
create trigger update_stock 
after insert on rental
for each row begin
  update inventory as i
  set i.stock = i.stock-1
  where i.inventory_id = new.inventory_id;
end //

delimiter ;

DELIMITER //

DROP TRIGGER IF EXISTS update_stock; //

CREATE TRIGGER update_stock 
AFTER INSERT ON rental
FOR EACH ROW 
BEGIN
    UPDATE inventory 
    SET stock = stock - 1
    WHERE inventory_id = NEW.inventory_id;
END //

DELIMITER ;

-- Cree una tabla `fines` que tenga dos campos: `rental_id` y `amount`. El primero es una clave foránea a la tabla rental y el segundo es un valor numérico con dos decimales.
create table fines (
  rental_id int,
  amount numeric(10,2),
  foreign key (rental_id) references rental(rental_id)
);

-- Cree un procedimiento `check_date_and_fine` que revise la tabla `rental` y cree un registro en la tabla `fines` por cada `rental` cuya devolución (return_date) haya tardado más de 3 días (comparación con rental_date). El valor de la multa será el número de días de retraso multiplicado por 1.5.

select rental_date, return_date, datediff(return_date, rental_date)-3 from rental limit 10;

delimiter //

create procedure check_date_and_fine()
begin
  insert into fines (rental_id, amount)
  select rental_id as id, (datediff(return_date,rental_date)-3) * 1.5 as multa 
  from rental 
  where (datediff(return_date,rental_date)-3 * 1.5) > 0;
end //
  
delimiter ;

--   for r as
--   do
--     if r.retraso > 0 then
--       set multa = r.retraso * 1.5;
--       insert into fines (rental_id, amount)
--         values(r.id, multa);
--       end if
--     set multa = 0;
--   end for
-- end
--   retraso = select rental_date, return_date, datediff(return_date, rental_date)-3 from rental limit 10;
-- multa = retraso * 1.5


-- Crear un rol `employee` que tenga acceso de inserción, eliminación y actualización a la tabla `rental`.
create role employee;
grant insert on rental to employee;
grant delete on rental to employee;
grant update on rental to employee;

-- Revocar el acceso de eliminación a `employee` y crear un rol `administrator` que tenga todos los privilegios sobre la BD `sakila`.
revoke delete on rental from employee;
create role administrator;
grant all privileges on sakila.* to administrator;

-- Crear dos roles de empleado. A uno asignarle los permisos de `employee` y al otro de `administrator`.
create role employee_role;
create role administrator_role;
grant employee to employee_role;
grant employee to administrator_role;








