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

--5) Las actividades que no registran ning�n socio inscripto.
select * from Actividades where Actividades.ID not in (
select distinct Inscripciones.IDActividad from Inscripciones )

--6) Las actividades que no registran ning�n socio becado (XLS).
select * from Actividades where Actividades.ID not in (
select distinct Inscripciones.IDActividad from Inscripciones where Becado = 1
)

--7) Las actividades cuyo costo sea mayor a alguna actividad que requiera Apto M�dico (XLS).
select * from Actividades where Actividades.Costo > some (
select distinct Actividades.Costo from Actividades where AptoMedico = 1
)

--8) Las actividades cuyo costo sea menor a cualquier actividad que requiera Apto M�dico (XLS).
--9) Las actividades cuyo costo sea mayor a cualquier actividad que se realice en la Sede 2.
--10) Por cada actividad, el nombre y la cantidad de inscriptos de g�nero masculino y la cantidad de
--inscriptos de g�nero femenino.
--11) Por cada socio, la cantidad de actividades que requieren apto m�dico que realiza y la cantidad de
--actividades que no requieren apto m�dico (XLS).
--12) La cantidad de actividades que registraron la misma cantidad de socios de g�nero masculino
--que socios de g�nero femenino.
--13) El porcentaje de inscripciones realizadas en el a�o actual con respecto al total de inscripciones.
--14) Las actividades que registran la misma cantidad de socios de g�nero masculino que socios de
--g�nero femenino.
--15) Los socios que realizan �nicamente actividades que no requiere apto m�dico.
--16) Los socios que realicen m�s actividades que requieren apto m�dico que actividades que no lo
--requieran y que al menos realicen una actividad que no requiera apto m�dico (XLS).