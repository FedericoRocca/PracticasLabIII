--1) Las actividades con el mayor costo.
select * from Actividades where Actividades.Costo =
(
	select max(Actividades.Costo) from Actividades
)

--2) Los pagos con el menor importe.
select * from Pagos
where Pagos.Importe = ( select min(Pagos.Importe) from Pagos )

--3) Las actividades cuyo precio sea mayor al precio promedio (XLS).
select * from Actividades where Actividades.Costo < (
select avg(Actividades.Costo) from Actividades
)

--4) Los socios que no se inscribieron a ninguna actividad (XLS).
select * from Socios
where Socios.Legajo not in (
select distinct Inscripciones.Legajo from Inscripciones
)

--5) Las actividades que no registran ningún socio inscripto.
select * from Actividades where Actividades.ID not in (
select distinct Inscripciones.IDActividad from Inscripciones )

--6) Las actividades que no registran ningún socio becado (XLS).
select * from Actividades where Actividades.ID not in (
select distinct Inscripciones.IDActividad from Inscripciones where Becado = 1
)

--7) Las actividades cuyo costo sea mayor a alguna actividad que requiera Apto Médico (XLS).
select * from Actividades where Actividades.Costo > some (
	select distinct Actividades.Costo from Actividades where AptoMedico = 1
)

--8) Las actividades cuyo costo sea menor a cualquier actividad que requiera Apto Médico (XLS).
select Actividades.Nombre, Actividades.Costo from Actividades where Actividades.Costo < some (
	select distinct Actividades.Costo from Actividades where Actividades.AptoMedico = 1
)

--9) Las actividades cuyo costo sea mayor a cualquier actividad que se realice en la Sede 2.
select Actividades.Nombre, Actividades.Costo from Actividades where Actividades.Costo > any (
	select distinct Actividades.Costo from Actividades where Actividades.IDSede = 2
)

--10) Por cada actividad, el nombre y la cantidad de inscriptos de género masculino y la cantidad de
--inscriptos de género femenino.
select Actividades.Nombre, 
(
	select count(distinct Socios.Legajo) from Inscripciones
	inner join Socios on (Inscripciones.Legajo = Socios.Legajo)
	where Socios.Genero = 'F' and Actividades.ID = Inscripciones.IDActividad
) as 'Femeninos',
(
	select count(distinct Socios.Legajo) from Inscripciones
	inner join Socios on (Inscripciones.Legajo = Socios.Legajo)
	where Socios.Genero = 'M' and Actividades.ID = Inscripciones.IDActividad
) as 'Masculinos'
from Actividades

--11) Por cada socio, la cantidad de actividades que requieren apto médico que realiza y la cantidad de
--actividades que no requieren apto médico (XLS).
select Socios.Legajo, Socios.Nombres, Socios.Apellidos,
(
	select count(distinct Actividades.Nombre) from Actividades 
	inner join Inscripciones on (Inscripciones.IDActividad = Actividades.ID)
	where Actividades.AptoMedico = 1 and Socios.Legajo = Inscripciones.Legajo
) as 'Con apto médico',
(
	select count(distinct Actividades.Nombre) from Actividades 
	inner join Inscripciones on (Inscripciones.IDActividad = Actividades.ID)
	where Actividades.AptoMedico = 0 and Socios.Legajo = Inscripciones.Legajo
) as 'Sin apto médico'
from Socios

--12) La cantidad de actividades que registraron la misma cantidad de socios de género masculino
--que socios de género femenino.
select count (*) as 'Cantidad de actividades' from
(
	select Actividades.Nombre, 
	(
		select count(*) from Inscripciones
		inner join Socios on (Inscripciones.Legajo = Socios.Legajo)
		where Genero = 'M' and Actividades.ID = Inscripciones.IDActividad
	) as cantM,
	(
		select count(*) from Inscripciones
		inner join Socios on (Inscripciones.Legajo = Socios.Legajo)
		where Genero = 'F' and Actividades.ID = Inscripciones.IDActividad
	) as cantF
	from Actividades
) as auxTable
where cantM = cantF

--13) El porcentaje de inscripciones realizadas en el año actual con respecto al total de inscripciones.
select (
	select count(*)*100.0 from Inscripciones
	where year(Inscripciones.FechaInscripcion) = 2019 -- Cambio
	)/(
	select count(*) from Inscripciones
) as promedio

--14) Las actividades que registran la misma cantidad de socios de género masculino que socios de
--género femenino.
select * from
(
	select Actividades.Nombre,
	(
		select count(*) from Inscripciones
		inner join Socios on (Socios.Legajo = Inscripciones.Legajo)
		where Socios.Genero = 'M' and Actividades.ID = Inscripciones.IDActividad
	) as cantM,
	(
		select count(*) from Inscripciones
		inner join Socios on (Socios.Legajo = Inscripciones.Legajo)
		where Socios.Genero = 'F' and Actividades.ID = Inscripciones.IDActividad
	) as cantF
	from Actividades
) as tmp
where tmp.cantM = tmp.cantF

--15) Los socios que realizan únicamente actividades que no requiere apto médico.
select * from
(
	select Socios.Apellidos, Socios.Nombres, 
	(
		select count(*) from Actividades
		inner join Inscripciones on (Actividades.ID = Inscripciones.IDActividad)
		where Actividades.AptoMedico = 1 and Inscripciones.Legajo = Socios.Legajo
	) as Requiere,
	(
		select count(*) from Actividades
		inner join Inscripciones on (Actividades.ID = Inscripciones.IDActividad)
		where Actividades.AptoMedico = 0 and Inscripciones.Legajo = Socios.Legajo
	) as NoRequiere
	from Socios
) as lista
where lista.Requiere = 0 and lista.NoRequiere > 0

--16) Los socios que realicen más actividades que requieren apto médico que actividades que no lo
--requieran y que al menos realicen una actividad que no requiera apto médico (XLS).
select * from
(
	select Socios.Apellidos, Socios.Nombres, 
	(
		select count(*) from Actividades
		inner join Inscripciones on (Actividades.ID = Inscripciones.IDActividad)
		where Actividades.AptoMedico = 1 and Inscripciones.Legajo = Socios.Legajo
	) as Requiere,
	(
		select count(*) from Actividades
		inner join Inscripciones on (Actividades.ID = Inscripciones.IDActividad)
		where Actividades.AptoMedico = 0 and Inscripciones.Legajo = Socios.Legajo
	) as NoRequiere
	from Socios
) as lista
where lista.Requiere > lista.NoRequiere and lista.NoRequiere > 0