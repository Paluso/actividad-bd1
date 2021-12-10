-- Creacion de esquema:
create schema if not exists farmacia;
-- Para mostrar los esquemas existentes en la BD:
show schemas;
-- Para eliminar un esquema:
drop schema farmacia;
-- Para establecer el esquema sobre el que trabajamos:
use farmacia;
-- Para cosultar cual es el esquema en uso:
select schema();
-- Creamos la tabla obra_social en el esquema activo:
create table obra_social(
	codigo int primary key,
	nombre varchar(45) not null,
	descripcion varchar(100) not null
);
-- Para mostrar la definición de la tabla:
show create table obra_social;
-- para mostrar las tablas definidas en el esquema 
-- activo:
show tables;

-- para eliminar una tabla
drop table obra_social;

-- Para renombrar una tabla:
alter table obra_social rename to obra;
alter table obra rename to obra_social;

-- Para cambiar la columna descripcion a descr
-- (hay que indicar todos los datos de la columna):
alter table obra_social change column descripcion descr varchar(100);
alter table obra_social change column descr descripcion varchar(100);

-- Insertamos datos en la tabla:
insert into obra_social values(1,"PAMI","Programa de Atención Médica Integral");

insert into obra_social (codigo, nombre, descripcion) values(2,"IOMA","Instituto de Obra Medico Asistencial");

insert into obra_social (codigo, nombre, descripcion) values(3,"OSECAC","Obra Social de Empleados de Comercio");

-- Consultamos los registos insertados
select * from obra_social;



--  Creamos la tabla provincia en el esquema farmacia:
create table provincia(
	codigo int primary key,
    nombre varchar(100) not null
);
drop table provincia;
create table provincia(
	codigo int primary key,
    nombre varchar(100) not null
    );
alter table provincia rename to prov;
alter table prov rename to provincia;

alter table provincia change column nombre nom varchar(100);
alter table provincia change column nom nombre varchar(100);
insert into provincia values (1,"Buenos Aires");
insert into provincia values (2,"CABA");
select * from provincia;

--  Creamos la tabla localidad en el esquema farmacia:
create table localidad(
	codigo int primary key,
    nombre varchar(100) not null
);
alter table localidad rename to loc;
alter table loc rename to localidad;

alter table localidad change column codigo cod varchar(100);
alter table localidad change column cod cogido varchar(100);

insert into localidad values(1,"Lanus");
insert into localidad values(2,"Pompella");
insert into localidad values(3,"Avellaneda");
select*from localidad;

--  Creamos la tabla calle en el esquema farmacia:
create table calle(
	codigo int primary key,
    nombre varchar(100) not null
    );

alter table calle rename to cal;
alter table cal rename to calle;

alter table calle change column nombre nom varchar(100);
alter table calle change column nom nombre varchar(100);

insert into calle values(1,"9 de Julio");
insert into calle values(2,"Hipolito Yrigoyen");
insert into calle values(3,"Mitre");
insert into calle values(4,"Saenz");
select*from calle;
    

-- Creamos la tabla Cliente en el esquema farmacia;

create table cliente(
	dni int primary Key,
    apellido varchar(45)not null,
    nombre varchar(45)not null,
    calle_idcalle int not null,
    localidad_idlocalidad int not null,
    provincia_idprovincia int not null,
    numero_calle int not null,
    foreign Key(calle_idcalle) references calle(codigo),
    foreign Key(localidad_idlocalidad) references localidad(codigo),
    foreign Key (provincia_idprovincia) references provincia(codigo)
    );
    
show create table cliente;

-- Agregamos registros:
insert into cliente values(12345678, "Belgrano", "Manuel", 1,1,1,2345);
insert into cliente values(23456789, "Saavedra", "Cornelio",1,1,1,1234);
insert into cliente values(44444444, "Moreno", "Mariano", 3,3,1,3333);
insert into cliente values(33333333, "Larrea", "Juan", 4,2,2,2345);
insert into cliente values(22222222, "Moreno", "Manuel", 4,2,2,7777);

-- Mostramos todos los clientes:
select * from cliente;
-- Mostramos solo dni y apellid:
select dni,apellido from cliente;
-- Consultamos registros por dni:
select nombre, apellido from cliente where dni=12345678;
-- Consultamos registros por apellido
select * from cliente where apellido="Saavedra";
-- Consultamos clientes en la calle 9 de Julio(1)
select * from cliente where calle_idcalle=1;
-- Consultamos clientes de la calle 9 de julio con el numero 2345
select * from cliente where calle_idcalle=1 and numero_calle=2345;
-- Consultamos clientes que vivan en la calle 9 de Julio o en la calle Mitre
select * from cliente where calle_idcalle=1 or calle_idcalle=3;
-- Consultar que codigo de idenficador tiene la calle Mitre
select codigo from calle where nombre="Mitre";

create table cliente_tiene_obra_social(
	cliente_dni int primary key,
    cod_obra_social int not null,
    nro_afiliado int not null,
    foreign key (cliente_dni) references cliente(dni),
    foreign Key (cod_obra_social) references obra_social(codigo)
);

insert into cliente_tiene_obra_social values (22222222, 2, 11223344);
insert into cliente_tiene_obra_social values (33333333, 2, 33445566);
insert into cliente_tiene_obra_social values (44444444, 2, 12356987);
insert into cliente_tiene_obra_social values (12345678, 1, 87654321);

-- Consultamos todos los clientes con su calle usando alias de tabla
-- Inner join: todos los registros de una tabla con correlato en la otra
select c.dni, c.apellido, c.nombre, ca.nombre, c.numero_calle 
from cliente c 
inner join calle ca on c.calle_idcalle=ca.codigo;

-- igual, definiendo un alias para el campo c.nombre y numero_calle
-- (con as)
select c.dni, c.apellido, c.nombre, ca.nombre as calle, c.numero_calle as numero
from cliente c 
inner join calle ca on c.calle_idcalle=ca.codigo;

-- inner join con filtro por nombre de localidad
select c.dni, c.apellido, c.nombre, l.nombre as Localidad 
from cliente c
inner join localidad l on c.localidad_idlocalidad=l.codigo
where l.nombre="Avellaneda";

-- Left join: Todos los registros de la izquierda y sólo los de la
-- derecha que participan en la relación.
select ca.nombre as calle, c.dni, c.apellido, c.nombre from calle ca
left join cliente c on ca.codigo=c.calle_idcalle;

-- Right join: Todos los registros de la derecha y los de la izquierda que
-- participan en la relación.
select cos.nro_afiliado, dni, apellido, c.nombre
from cliente_tiene_obra_social cos right join cliente c on
c.dni=cos.cliente_dni;

-- Vemos como un right join se puede escribir como un left join y
-- viceversa. Esta consulta es similar a la anterior
select cos.nro_afiliado, dni, apellido, c.nombre from cliente c
left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni;

-- Traemos a los clientes sin obra social
select cos.nro_afiliado, dni, apellido, c.nombre from cliente c
left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni
where isnull(cos.nro_afiliado);


select c.dni, c.apellido, c.nombre, o.nombre
from cliente c
inner join cliente_tiene_obra_social co on c.dni=co.cliente_dni
inner join obra_social o on co.cod_obra_social=o.codigo
where o.nombre="IOMA";

-- Práctica:
-- consultar por:
-- Todos los clientes con la siguiente forma:
-- dni, apellido,nombre,calle,numero,localidad,provincia :
select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia;
    
-- Igual que la anterior pero sólo de la provincia de Buenos Aires:
select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia
	where p.nombre="Buenos Aires";
    
-- Igual que la primera pero sólo de la calle 9 de julio:
select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia
	where ca.nombre="9 de julio";

-- Igual que la primera pero sólo el dni 33333333:
select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia
	where c.dni="33333333";
    
-- Igual que la primera pero sólo de las localidades:
-- de avellaneda y lanus (filtrar por "Avellaneda" y "Lanús"):
select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia
	where l.nombre="Avellaneda";

select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia
	where l.nombre="Lanus";
    
-- Igual que la primera pero sólo los clientes de PAMI y IOMA (filtrar por "PAMI" y "IOMA"):
select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre,o.nombre as obraSocial
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia
    inner join cliente_tiene_obra_social co on c.dni=co.cliente_dni
	inner join obra_social o on co.obra_social_codigo=o.codigo
	where o.nombre="PAMI";
    
select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre,o.nombre as obraSocial
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia
    inner join cliente_tiene_obra_social co on c.dni=co.cliente_dni
	inner join obra_social o on co.obra_social_codigo=o.codigo
	where o.nombre="IOMA";

select c.dni,c.apellido,c.nombre,ca.nombre as calle,c.numero_calle as numero,l.nombre,p.nombre,o.nombre as obraSocial
	from cliente c
    inner join calle ca on ca.codigo=c.calle_idcalle
    inner join localidad l on l.codigo=c.localidad_idlocalidad
    inner join provincia p on p.codigo=c.provincia_idprovincia
    inner join cliente_tiene_obra_social co on c.dni=co.cliente_dni
	inner join obra_social o on co.obra_social_codigo=o.codigo
	where o.nombre="IOMA" and ca.nombre="Mitre";
    
-- Crear las tablas laboratorio y producto:
-- insertar los siguientes datos:
-- laboratorio:
create table laboratorio(
	codigo int primary Key,
    nombre varchar(40) not null
    );
    
insert into laboratorio values(1, 'Bayer');
insert into laboratorio values(2, 'Roemmers');
insert into laboratorio values(3, 'Farma');
insert into laboratorio values(4, 'Elea');
select*from laboratorio;

-- Porducto:
create table producto(
	codigo int primary Key,
    nombre varchar(40) not null,
    descripcion varchar(100) not null,
    precio int not null,
    laboratorio_codigo int not null,
    foreign Key (laboratorio_codigo) references laboratorio(codigo)
    );
    show create table producto;
    
insert into producto values(1, 'Bayaspirina', 'Aspirina por tira de 10 unidades', 10, 1);
insert into producto values(2, 'Ibuprofeno', 'Ibuprofeno por tira de 6 unidades', 20, 3);
insert into producto values(3, 'Amoxidal 500', 'Antibiótico de amplio espectro', 300, 2);
insert into producto values(4, 'Redoxon', 'Complemento vitamínico', 120, '1');
insert into producto values(5, 'Atomo', 'Crema desinflamante', 90, 3);
select * from producto;

-- Crear tabla venta. Insertar los siguientes datos:
create table venta(
numero int primary Key,
fecha date not null,
cliente_dni int not null,
foreign Key (cliente_dni) references cliente(dni)
);
show create table venta;

insert into venta values(1, '20-08-20', 12345678);
insert into venta values(2, '20-08-20', 33333333);
insert into venta values(3, '20-08-22', 22222222);
insert into venta values(4, '20-08-22', 44444444);
insert into venta values(5, '20-08-22', 22222222);
insert into venta values(6, '20-08-23', 12345678);
insert into venta values(13,'21-08-20', 23456789);
insert into venta values(14,'21-08-20', 23456789);
select*from venta;

-- Realizar las siguientes consultas:
-- - Todas las ventas, indicando número, fecha, apellido y nombre del cliente:
select v.numero,v.fecha,c.apellido,c.nombre
from cliente c
	right join venta v on v.cliente_dni=c.dni;
    
-- - Igual que la anterior, pero que traiga sólo las del cliente con dni 12345678
select v.numero,v.fecha,c.apellido,c.nombre
from cliente c
	right join venta v on v.cliente_dni=c.dni
    where c.dni="12345678";

-- Todos (pero todos) los clientes con sus ventas
select v.numero,v.fecha,c.apellido,c.nombre
from cliente c
	left join venta v on v.cliente_dni=c.dni;

-- - Los clientes que no tienen ventas registradas
select v.numero,v.fecha,c.apellido,c.nombre
from cliente c
	left join venta v on v.cliente_dni=c.dni
    where isnull(v.numero);

-- - Todos los laboratorios
select*from laboratorio;

-- - Todos los productos, indicando a que laboratorio pertencen
select * from producto p
	inner join laboratorio l on l.codigo=p.laboratorio_codigo;
    
-- - Todos (pero todos) los laboratorios con los productos que elaboran
select * from laboratorio l
	left join producto p on p.laboratorio_codigo=l.codigo;
    
-- - Los laboratorios que no tienen productos registrados
select*from laboratorio l
	left join producto p on p.laboratorio_codigo=l.codigo
	where isnull(p.codigo);
    
    
    
-- Actividad 8 
-- creamos la tabla detalle_venta (¿Qué representa esta tabla?)
create table detalle_venta(
venta_numero int,
producto_codigo int,
precio_unitario decimal(10,2),
cantidad int,
primary key (venta_numero, producto_codigo),
foreign key (venta_numero) references venta(numero),
foreign key (producto_codigo) references producto(codigo)
);

-- Agregar el detalle de las ventas en detalle_venta de la siguiente manera:
-- # venta_numero, producto_codigo, precio_unitario, cantidad
insert into detalle_venta values(1, 2, 20.00, 3);
insert into detalle_venta values(1, 3, 300.00, 1);
insert into detalle_venta values(2, 1, 10.00, 2);
insert into detalle_venta values(2, 4, 120.00, 1);
insert into detalle_venta values(3, 2, 20.00, 3);
insert into detalle_venta values(3, 5, 90.00, 2);
insert into detalle_venta values(4, 2, 20.00, 2);
insert into detalle_venta values(5, 1, 8.00, 4);
insert into detalle_venta values(5, 5, 70.00, 1);
insert into detalle_venta values(6, 2, 20.00, 2);
insert into detalle_venta values(6, 3, 300.00, 1);
insert into detalle_venta values(6, 4, 120.00, 1);
insert into detalle_venta values(7, 4, 120.00, 2);
insert into detalle_venta values(4, 2, 20.00, 2);
insert into detalle_venta values(13, 2, 20.00, 2);
insert into detalle_venta values(13, 3, 300.00, 2);

-- Total facturado para un ítem determinado de una venta:
select precio_unitario*cantidad as total from detalle_venta
where venta_numero=1 and producto_codigo=2;
-- Total facturado por la farmacia
select sum(precio_unitario*cantidad) as total from detalle_venta;
-- Detalle de cada compra
select * from detalle_venta;
-- Total facturado en una venta
select sum(precio_unitario*cantidad) as total from detalle_venta
where venta_numero=1;
-- Total facturado discriminado venta por venta (sum con group by):
select venta_numero, sum(precio_unitario*cantidad) as total from
detalle_venta
group by venta_numero;

-- Cantidad de ventas COUNT
select count(*) as cant_ventas from venta;

-- Cantidad de ventas por dia total (count con group by)
select fecha, count(*) as cant_ventas from venta
group by fecha;

-- precio promedio de productos vendidos por producto (inner join, avg,
-- group by)
select p.nombre, avg(dv.precio_unitario) as precio_promedio, p.precio as
precio_lista
from producto p
inner join detalle_venta dv on p.codigo=dv.producto_codigo
group by p.codigo;

-- precio promedio de productos vendidos entre fecha (inner join, avg,
-- group by, between)
select p.nombre, avg(dv.precio_unitario) as precio_promedio, p.precio as
precio_lista
from producto p
inner join detalle_venta dv on p.codigo=dv.producto_codigo
inner join venta v on dv.venta_numero=v.numero
where v.fecha between '2020-08-22' and '2020-08-23'
group by p.codigo;

-- artículos vendidos más baratos que el precio de lista
select v.numero, p.nombre, p.descripcion, p.precio as precio_lista,
dv.precio_unitario as precio_venta,
dv.precio_unitario-p.precio as diferencia
from venta v
inner join detalle_venta dv on v.numero=dv.venta_numero
inner join producto p on dv.producto_codigo=p.codigo
where dv.precio_unitario-p.precio<0;

-- total facturado en el año (inner join, sum, where)
select year(v.fecha) as año, sum(precio_unitario*cantidad) as total
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
group by year(v.fecha);

-- Total facturado mayor a $100 (sum con group by y having):
select venta_numero, sum(precio_unitario*cantidad) as total from
detalle_venta
group by venta_numero
having total>100;

-- Total facturado mayor a $100 (sum con group by y having, ordenado por
-- total):
select venta_numero, sum(precio_unitario*cantidad) as total from
detalle_venta
group by venta_numero
having total>100
order by total;

-- Total facturado mayor a $100 (sum con group by y having, ordenado por
-- total):
select venta_numero, sum(precio_unitario*cantidad) as total from
detalle_venta
group by venta_numero
having total>100
order by total desc;

-- Realizar una consulta que devuelva el total facturado del
-- producto 'Amoxidal 500' pero eligiendo el producto por nombre 
-- (no por código). 
select p.nombre, precio_unitario*cantidad as total from
detalle_venta dv
inner join producto p on p.codigo=dv.producto_codigo
where p.nombre='Amoxidal 500';

-- Realizar una consulta que devuelva el total facturado al cliente con dni 
-- 22222222 (dni, total)
select c.dni, sum(precio_unitario*cantidad) as total from detalle_venta dv
inner join venta v on v.numero=dv.venta_numero
inner join cliente c on c.dni=v.cliente_dni
where c.dni=22222222;

-- Realizar una consulta que devuelva la cantidad de ventas realizadas al 
-- cliente con dni 12345678. Cantidad de ventas es cada ticket emitido, no cada 
-- producto vendido. (dni, cantidad)
select c.dni, count(*) as cantidad from venta v
inner join cliente c on c.dni=v.cliente_dni
where c.dni=12345678;

-- Realizar una consulta que devuelva las ventas realizadas a los clientes con apellido
-- 'Belgrano', discriminado venta por venta. (apellido, numero de venta, total) FALTA
select c.apellido, dv.venta_numero as NumeroDeVenta, sum(dv.precio_unitario*dv.cantidad) as total
from venta v
inner join detalle_venta dv on dv.venta_numero=v.numero
right join cliente c on c.dni=v.cliente_dni
where c.apellido='Belgrano'
group by c.nombre;

-- Realizar una consulta que devuelva la cantidad de ventas realizadas a los clientes 
-- con apellido 'Moreno'. (apellido, cantidad) FALTA
select c.apellido, count(dv.venta_numero) as NumeroDeVenta
from venta v
inner join detalle_venta dv on dv.venta_numero=v.numero
inner join cliente c on c.dni=v.cliente_dni
where c.apellido='Moreno';

-- Traer el total facturado por obra social. (nombre de obra social, total)
select o.nombre, sum(dv.precio_unitario*dv.cantidad) as total
from detalle_venta dv
inner join venta v on v.numero=dv.venta_numero
inner join obra_social o on o.codigo=v.numero
group by o.nombre;

-- Idem a la anterior, pero filtrando desde el 1/1/2020 hasta el 30/8/2020. 
select o.nombre, sum(dv.precio_unitario*dv.cantidad) as total
from detalle_venta dv
inner join venta v on v.numero=dv.venta_numero
inner join obra_social o on o.codigo=v.numero
where v.fecha between '2020-01-01' and '2020-08-30'
group by o.nombre;

-- Traer el total facturado a clientes que no tienen obra social(sólo mostrar total)
select sum(dv.cantidad*dv.precio_unitario) as total
from cliente_tiene_obra_social co
inner join cliente c on c.dni=co.cliente_dni
inner join venta v on c.dni=v.cliente_dni
inner join detalle_venta dv on dv.venta_numero=v.numero
where isnull(co.nro_afiliado);

-- Realizar una consulta que devuelva el total de las ventas realizadas a 
-- clientes de la calle Sáenz (se debe filtrar por nombre de calle="Sáenz").
-- (apellido, nombre, total vendido)
select v.fecha,ca.nombre as calle, c.apellido, c.nombre,sum(dv.precio_unitario*dv.cantidad) as total
from detalle_venta dv
inner join venta v on v.numero=dv.venta_numero
inner join cliente c on c.dni=v.cliente_dni
inner join calle ca on c.calle_idcalle=ca.codigo
where ca.nombre='Saenz'
group by ca.nombre='Saenz';


-- Realizar una consulta que devuelva las ventas realizadas a clientes de la 
-- calle Sáenz (se debe filtrar por nombre de calle="Sáenz", discriminada 
-- venta por venta (venta_numero, total)

-- Realizar una consulta que devuelva los productos vendidos. Se debe mostrar cada 
-- producto una sola vez (Ayuda: hay que agrupar por producto)

-- Realizar una consulta que devuelva el total de ventas sin detallar realizadas 
-- a clientes de la obra social IOMA que vivan en la provincia de Buenos Aires. -- Consultar por nombre de obra social y de provincia

-- Realizar una consulta que devuelva cuántas son las ventas de la consulta anterior



/***************************************************************************************
Apunte 6-Elementos de SQL 4
***************************************************************************************/

-- Problema con group by en MySQL (consulta incorrecta):
select venta_numero, venta.fecha, sum(precio_unitario*cantidad) as total 
from detalle_venta
inner join venta on venta.numero=detalle_venta.venta_numero;

-- Campos en select con dependencias funcionales con un campo en group by:
select c.dni,sum(precio_unitario*cantidad) as total_facturado, c.nombre, c.apellido
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
inner join cliente c on v.cliente_dni=c.dni
group by c.dni;

-- Campos en select sin dependencia funcional con algún campo en group by (incorrecta)
-- debe devolver error, si no es así, verificar sql_mode:
select c.dni,sum(precio_unitario*cantidad) as total_facturado, c.nombre, c.apellido, v.fecha
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
inner join cliente c on v.cliente_dni=c.dni
group by c.dni;

-- Campos en select sin dependencia funcional con alguno en group by,
-- pero en función de agregación:
select c.dni,sum(precio_unitario*cantidad) as total_facturado, c.nombre, c.apellido,
max(v.fecha) as fecha_ultima_venta
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
right join cliente c on v.cliente_dni=c.dni
left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni
group by c.dni;

/***************************************************************************************
Modificamos (update) registros
******************************************************************/
-- agregamos 20% al precio de todos los productos
update producto set precio=precio*1.2; 

select * from producto;

-- agregamos 15% al precio de los productos Bayer
update producto set precio=precio*1.15 
	where laboratorio_codigo=1;

select * from producto;

-- agregamos 10% a un producto determinado
update producto set precio=precio*1.1 
	where nombre="Amoxidal 500";

select * from producto;

-- agregamos 10% a los productos cuyo precio sea >150
update producto set precio=precio*1.1 
	where precio>150;

select * from producto;

-- podemos actualizar varios campos a la vez separando con comas.
-- aquí utilizamos una función de MySQL para concatenar dos strings
-- year, sum, count, avg también son funciones. 
-- Listado de funciones de MySQL:
-- https://dev.mysql.com/doc/refman/8.0/en/sql-function-reference.html
update producto set precio=precio*1.1, descripcion=concat(descripcion," nueva fórmula")
	where nombre="Amoxidal 500";

select * from producto;

/***************************************************************************************
Eliminamos (delete) registros
***************************************************************************************/

-- damos de alta una obra social para luego eliminarla
insert into obra_social (codigo, nombre, descripcion) 
	values(4,"OSPAPEL","Obra Social del personal del papel");

select * from obra_social;

-- la eliminamos
delete from obra_social where codigo=4;

select * from obra_social;

-- si no especificamos filtro, podemos borrar todas las 
-- obras sociales
delete from obra_social;
-- Se pudo? Por qué?


/*********ACTIVIDAD 9************/
-- Realizar una consulta que traiga el total de las ventas de un cliente, indicando apellido, 
-- nombre, dni, localidad y total de ventas.
 select c.apellido, c.nombre, c.dni, loc.nombre, sum(precio_unitario*cantidad) as total
 from cliente c 
 inner join venta v on c.dni=v.cliente_dni
 inner join detalle_venta dv on dv.venta_numero=v.numero
 inner join localidad loc on c.localidad_idlocalidad=loc.codigo
 where c.dni=22222222;
 
 -- Realizar una consulta que traiga el total de las ventas por provincia, indicando provincia, 
-- total de ventas.
select sum(precio_unitario*cantidad) as total, pr.nombre
from detalle_venta dv
inner join venta v on v.numero=dv.venta_numero
inner join cliente c on v.cliente_dni=c.dni
inner join provincia pr on pr.codigo=c.provincia_idprovincia
group by pr.nombre;

-- Realizar una consulta que devuelva el promedio de precio de venta por producto, mostrando 
-- producto, precio promedio. El precio de venta es el precio con que se vendió, no el precio 
-- de lista.
select p.nombre, avg(dv.precio_unitario) as precio_promedio, dv.precio_unitario as precio
from producto p
inner join detalle_venta dv on p.codigo=dv.producto_codigo
group by p.codigo;


-- Realizar una consulta que traiga totales de venta por provincia y obra social, indicando
-- provincia, codigo de obra social, nombre de obra social, descripcion de obra social, 
-- total venta.
select count(precio_unitario*cantidad) as total, pr.nombre, o.nombre
from detalle_venta dv
inner join venta v on v.numero=dv.venta_numero
inner join cliente c on c.dni=v.cliente_dni
inner join provincia pr on c.provincia_idprovincia=pr.codigo
inner join cliente_tiene_obra_social cob on cob.cliente_dni=c.dni
inner join obra_social o on cob.cod_obra_social=o.codigo
group by o.nombre;

-- Realizar una consulta que le cambie la obra social al cliente con dni 22222222.
update cliente_tiene_obra_social set cod_obra_social=2
	where cliente_dni=22222222;
select * from cliente_tiene_obra_social;

-- Realizar una consulta que retorne la obra social del cliente con dni 22222222 a la 
-- original (IOMA).
update cliente_tiene_obra_social set cod_obra_social=1
	where cliente_dni=22222222;
select * from cliente_tiene_obra_social;

-- Realizar las consultas necesarias para retornar los precios de lista de los productos 
-- a sus valores originales(Falta)
update producto set precio=precio; 

select * from producto;

-- Realizar una consulta que modifique al cliente Mariano Moreno para que quede sin obra social
select c.dni from cliente c
where c.nombre='Mariano' and c.apellido='Moreno';
delete from cliente_tiene_obra_social where cliente_dni=44444444;

    select * from cliente_tiene_obra_social;

/*****
-- Crear una venta número 7, de fecha  25/08/2020, al cliente Cornelio Saavedra, con los 
-- siguientes productos (producto, cantidad):

Amoxidal 500, 3
Bayaspirina, 10
Redoxon, 1
*******/
insert into venta values(7,'20-08-25',23456789);
insert into detalle_venta values(7,3,396.00,3);
insert into detalle_venta values(7,1,14.00,10);
insert into detalle_venta values(7,4,166.00,1);

-- Crear una consulta que Modifique el precio del artículo Redoxon de la venta 7 a $200
select * from detalle_venta dv
where dv.venta_numero=7;
update detalle_venta dv set precio_unitario=200
	where dv.venta_numero=7 and dv.producto_codigo=4;

-- Crear las consultas necesarias para eliminar completamente la venta 7, incluyendo su detalle. 
delete from detalle_venta  where venta_numero=7;
delete from venta where numero=7;
select * from detalle_venta;
select * from venta;
