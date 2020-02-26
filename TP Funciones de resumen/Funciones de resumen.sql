-- 1) La cantidad de socios.
select count(*) from Socios;

-- 2) La cantidad de socios que se identifican con el sexo femenino (XLS).
select count(*) from Socios
where Socios.Genero = 'F'

-- 3) La cantidad de socios que nacieron en el año 1990.
select count(*) from Socios
where Year(Socios.FechaNacimiento) = 1990

-- 4) El promedio de los importes de todos los pagos.
select avg(Pagos.Importe) from Pagos

-- 5) El promedio de los importes de todos los pagos realizados este año (XLS).
select avg(Pagos.Importe) from Pagos
where YEAR(Pagos.Fecha) = YEAR(getdate())

-- 6) La sumatoria de importes de todos los pagos.
select SUM(Pagos.Importe) from Pagos

-- 7) La sumatoria de importes de todos los pagos con estado 2 y 3 (XLS).
select sum(Pagos.Importe) from Pagos
where Pagos.Estado in (2,3)

-- 8) El importe máximo entre todos los pagos (XLS).
select max(Pagos.Importe) from Pagos

-- 9) La cantidad de actividades que requieran apto médico en la sede 2.
select COUNT(*) from Actividades
where Actividades.IDSede = 2 and Actividades.AptoMedico = 1

-- 10) El costo promedio de las actividades que no requieren apto médico.
select AVG(Actividades.Costo) from Actividades
where AptoMedico = 0

-- 11) El costo mínimo entre todas las actividades (XLS).
select min(Actividades.Costo) from Actividades

-- 12) La cantidad de actividades por sede. Listar el nombre de la sede y la cantidad de actividades
-- realizadas allí. (XLS)
select Sedes.Nombre, count(*) as "Cantidad Actividades" from Actividades
inner join Sedes on (Actividades.IDSede = Sedes.ID)
group by Sedes.Nombre

-- 13) La sumatoria de importes pagados por cada socio. Listar el apellido y nombres de todos los
-- socios y el total abonado. (XLS)
select Socios.Apellidos, Socios.Nombres, SUM(Pagos.Importe) from Pagos
inner join Socios on (Pagos.Legajo = Socios.Legajo)
group by Socios.Apellidos, Socios.Nombres

-- 14) El importe abonado por cada socio en cada año. Listar el apellido y nombres de todos los socios
-- y el total abonado por cada año.
select Socios.Apellidos, Socios.Nombres, year(Pagos.Fecha) as "Año", sum(Pagos.Importe) as "Total pagado" from Socios
inner join Pagos on (Socios.Legajo = Pagos.Legajo)
group by Socios.Apellidos, Socios.Nombres, year(Pagos.Fecha)

-- 15) La cantidad de actividades realizadas por socio. Listar el apellido y nombres de todos los socios
-- y la cantidad de actividades en las que se encuentra inscripto. Si un socio no se encuentra
-- inscripto a ninguna actividad debe figurar en el listado contabilizando 0. (XLS)
select Socios.Apellidos, Socios.Nombres, count(Inscripciones.IDInscripcion) from Socios
left join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
group by Socios.Apellidos, Socios.Nombres

-- 16) El costo de actividad más alto por cada sede. Listar el nombre de la sede y el importe de la
-- actividad más cara que se realiza allí (XLS).
select Sedes.Nombre, MAX(Actividades.Costo) from Actividades
inner join Sedes on (Sedes.ID = Actividades.IDSede)
group by Sedes.Nombre

-- 17) La cantidad de becados por género. Listar el género y la cantidad de becados de cada género.
select Socios.Genero, COUNT(*) as "Cantidad" from Inscripciones
inner join Socios on (Inscripciones.Legajo = Socios.Legajo)
where Inscripciones.Becado = 1
group by Socios.Genero

-- 18) Por cada socio la cantidad de sedes distintas a las que asiste. Indicar el apellido y nombre del
-- socio y la cantidad calculada (XLS).
-- 19) La cantidad de pagos de distinto importe registrados.
-- 20) La sumatoria de importes abonados por cada socio. Listar el apellido y nombres de los socios y
-- el total abonado. Sólo listar los socios que hayan abonado más de $3000 en total. (XLS)
-- 21) La sumatoria de importes menores a $1000 abonados por cada socio. Listar el apellido y
-- nombres de los socios y el total abonado. Sólo listar los socios que hayan abonado más de
-- $3000. (XLS)
-- 22) La cantidad de actividades realizadas por socio. Listar el apellido y nombres de todos los socios
-- y la cantidad de actividades en las que se encuentra inscripto. Sólo listar los socios que realicen
-- más de una actividad.
-- 23) La cantidad de socios por actividad. Listar el nombre de la actividad y la cantidad de socios
-- inscriptos a ella.
-- 24) Las actividades que no posean socios inscriptos. Listar el nombre de la actividad.