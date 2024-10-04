-- Devuelva la oficina con mayor número de empleados.
select count(*) as number_of_employees from employees group by officeCode;

-- ¿Cuál es el promedio de órdenes hechas por oficina?, ¿Qué oficina vendió la mayor cantidad de productos?
select avg(orders) from (
select count(*) as orders, employees.reportsTo from orders
join customers on customers.customerNumber = orders.customerNumber
join employees on employees.employeeNumber = customers.salesRepEmployeeNumber
group by employees.reportsTo 
) as ord
;

select count(*) as orders, employees.reportsTo from orders
join customers on customers.customerNumber = orders.customerNumber
join employees on employees.employeeNumber = customers.salesRepEmployeeNumber
group by employees.reportsTo
order by orders desc
limit 1;


-- Devolver el valor promedio, máximo y mínimo de pagos que se hacen por mes.
select avg(amount), max(amount), min(amount), 
monthname(payments.paymentDate) as month  
from payments
group by month
;

-- Crear un procedimiento "Update Credit" en donde se modifique el límite de crédito de un cliente con un valor pasado por parámetro.
delimiter //

create procedure update_credit(in credit_limit integer, in cn int(11))
begin
    update customers set creditLimit = credit_limit where customerNumber = cn;

end //

delimiter;


-- Cree una vista "Premium Customers" que devuelva el top 10 de clientes que más dinero han gastado en la plataforma. La vista deberá devolver el nombre del cliente, la ciudad y el total gastado por ese cliente en la plataforma.
create view premium_customers as
select customers.customerName, customers.city, sum(payments.amount) as gasto from customers 
join payments on payments.customerNumber = customers.customerNumber
group by customers.customerNumber
order by gasto desc limit 10
;

-- cree una función "employee of the month" que tome un mes y un año y devuelve el empleado (nombre y apellido) cuyos clientes hayan efectuado la mayor cantidad de órdenes en ese mes.
delimiter //

create function employee_of_the_month(mes int, ano int)
returns varchar(255)
deterministic
begin
    declare employee_info varchar(255);

    select concat(e.firstname, ' ', e.lastname, ' (orders: ', count(orders.ordernumber), ')') into employee_info
    from orders
    join customers on customers.customernumber = orders.customernumber
    join employees as e on e.employeenumber = customers.salesrepemployeenumber
    where month(orders.orderdate) = mes and year(orders.orderdate) = ano
    group by e.employeenumber, e.firstname, e.lastname
    order by count(orders.ordernumber) desc
    limit 1;

    return employee_info;
end //

delimiter ;

-- Crear una nueva tabla "Product Refillment". Deberá tener una relación varios a uno con "products" y los campos: `refillmentID`, `productCode`, `orderDate`, `quantity`.
create table product_refillment (
  refillmentID int primary key auto_increment,
  productCode varchar(15) not null,
  orderDate date,
  quantity int,
  foreign key (productCode) references products(productCode)
)
;

-- Definir un trigger "Restock Product" que esté pendiente de los cambios efectuados en `orderdetails` y cada vez que se agregue una nueva orden revise la cantidad de productos pedidos (`quantityOrdered`) y compare con la cantidad en stock (`quantityInStock`) y si es menor a 10 genere un pedido en la tabla "Product Refillment" por 10 nuevos productos.


delimiter //
create trigger restock_product 
after insert on orderdetails 
for each row begin
  declare quantityO int;
  declare quantityI int;

  set quantityO = new.quantityOrdered;
  select quantityInStock into quantityI from products where productCode = new.productCode;

  if  quantityI - quantityO < 10 then
    insert into product_refillment 
    (productCode, orderDate, quantity) 
    values(
      new.productCode,
      curdate(),
      10);
  end if;

end //


-- Crear un rol "Empleado" en la BD que establezca accesos de lectura a todas las tablas y accesos de creación de vistas.

create role empleado;
grant select on *.* to empleado; 
grant create view on *.* to empleado; 


-- Encontrar, para cada cliente de aquellas ciudades que comienzan por 'N', la menor y la mayor diferencia en días entre las fechas de sus pagos. No mostrar el id del cliente, sino su nombre y el de su contacto.
 

select customers.city, customers.customerName, 
datediff(max(payments.paymentDate), min(payments.paymentDate)) as max_dif_payment,
datediff(min(payments.paymentDate), 
 (select min(payments.paymentDate) from payments where payments.paymentDate > 
  (select min(payments.paymentDate) from payments)
 )
) as min_dif
from payments
join customers on customers.customerNumber = payments.customerNumber
where customers.city like "n%" 
group by payments.customerNumber;

-- Encontrar el nombre y la cantidad vendida total de los 10 productos más vendidos que, a su vez, representen al menos el 4% del total de productos, contando unidad por unidad, de todas las órdenes donde intervienen. No utilizar LIMIT.

