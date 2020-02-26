-- A) Abrir el archivo Joins.xls y realizar manualmente los listados que figuran en (B) que se
-- encuentran marcados con XLS.
-- B) Realizar las siguientes consultas de selección utilizando lenguaje SQL. Utilizar las cláusulas
-- vistas en el TP 1 en conjunto con las sentencias JOIN.
-- 1) Listar para cada actividad, todos los datos de la sede donde se realiza la actividad.
select Actividades.Nombre as "Actividad", Sedes.Direccion, Sedes.Mail, Sedes.Nombre as "Sede", Sedes.Telefono, Localidades.Nombre, Provincias.Nombre as "Provincia"
from Actividades
inner join Sedes on (Actividades.ID = Sedes.ID)
inner join Localidades on (Sedes.IDLocalidad = Localidades.ID)
inner join Provincias on (Localidades.IDProvincia = Provincias.ID)

-- 2) Listar el nombre y el costo de las actividades y la dirección, código postal y teléfono donde se
-- realiza la actividad. (XLS)
select Actividades.Nombre as "Actividad", Actividades.Costo, Sedes.Direccion, Localidades.ID as "Codigo postal", Sedes.Telefono
from Actividades
inner join Sedes on (Actividades.IDSede = Sedes.ID)
inner join Localidades on (Sedes.IDLocalidad = Localidades.ID)

-- 3) Listar el nombre y costo de todas las actividades que se realicen en el Código Postal 1111.
select Actividades.Nombre as "Actividad",  Actividades.Costo
from Actividades
inner join Sedes on (Actividades.ID = Sedes.ID)
inner join Localidades on (Sedes.IDLocalidad = Localidades.ID)
where Localidades.ID = 1111

-- 4) Listar el nombre, dirección y nombre de la localidad de todas las sedes. Incluir en el listado
-- aquellas localidades que no tengan una sede asociada completando con NULL los campos de la
-- sede que no pudo asociarse a la localidad. (XLS).
select Sedes.Nombre, Sedes.Direccion, Localidades.Nombre as "Localidad" from Sedes
right join Localidades on (Sedes.IDLocalidad = Localidades.ID)

-- 5) Listar el apellido y nombre y género de los socios que se encuentren becados (XLS).
select Socios.Apellidos, Socios.Nombres, Socios.Genero from Socios
inner join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
where Inscripciones.Becado = 1

-- 6) Listar el nombre de todas las actividades que realiza el socio con Legajo 1000.
select Actividades.Nombre from Socios
inner join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
inner join Actividades on (Inscripciones.IDActividad = Actividades.ID)
where Socios.Legajo = 1000

-- 7) Listar el nombre de todas las actividades que tengan algún inscripto en el año 2019 (sin
-- repeticiones).
select distinct Actividades.Nombre from Actividades
inner join Inscripciones on (Actividades.ID = Inscripciones.IDActividad)
where Inscripciones.FechaInscripcion like '%2019%'

select distinct Actividades.Nombre from Actividades
inner join Inscripciones on (Actividades.ID = Inscripciones.IDActividad)
where YEAR( Inscripciones.FechaInscripcion ) = 2019

-- 8) Listar el nombre, apellido, código de inscripción y fecha de inscripción de las inscripciones que
-- haya realizado un socio. Incluir en el listado a los socios que no poseen inscripciones
-- completando con NULL los campos de la inscripción que no pudo asociarse al socio. (XLS)
select Socios.Nombres, Socios.Apellidos, Inscripciones.FechaInscripcion as "Fecha de inscripcion", Inscripciones.IDInscripcion from Socios
left join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)

-- 9) Listar el nombre y apellido de los socios que no realicen ninguna actividad (que no posean
-- inscripciones) (XLS).
Select Socios.Nombres, Socios.Apellidos from Socios
left join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
where Inscripciones.FechaInscripcion is null

-- 10) Listar el nombre y apellido del socio, nombre de actividad y costo de la actividad de todos los
-- socios de sexo femenino que realicen actividades que requieren apto médico. (XLS)
select distinct Socios.Apellidos, Socios.Nombres, Actividades.Nombre as "Actividad", Actividades.Costo
from Socios
inner join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
inner join Actividades on (Inscripciones.IDActividad = Actividades.ID)
where Socios.Genero = 'M' and Actividades.AptoMedico = 1

-- 11) Listar nombre y apellido del socio, nombre de la actividad y nombre de la sede donde la realiza
-- de aquellos socios que se encuentren becados en dicha actividad.
select Socios.Nombres, Socios.Apellidos, Actividades.Nombre as "Actividad", Sedes.Nombre as "Sede"
from Socios
inner join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
inner join Actividades on (Inscripciones.IDActividad = Actividades.ID)
inner join Sedes on (Actividades.IDSede = Sedes.ID)
where Inscripciones.Becado = 1

-- 12) Listar el nombre de la actividad y el nombre de la localidad donde se realiza ordenado
-- ascendentemente por el nombre de la actividad.
select Actividades.Nombre, Localidades.Nombre as "Localidad" from Actividades
inner join Sedes on (Actividades.IDSede = Sedes.ID)
inner join Localidades on (Sedes.IDLocalidad = Localidades.ID)
order by Actividades.Nombre ASC

-- 13) Listar el apellido y nombres de todos los socios (sin repeticiones) que realicen alguna actividad
-- en San Fernando o Tigre.
select distinct Socios.Apellidos, Socios.Nombres from Socios
inner join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
inner join Actividades on (Inscripciones.IDActividad = Actividades.ID)
inner join Sedes on (Actividades.IDSede = Sedes.ID)
inner join Localidades on (Sedes.IDLocalidad = Localidades.ID)
where Localidades.ID in (1111,3333)

-- 14) Listar el socio que haya pagado la cuota más cara indicando el apellido y nombre del socio, el
-- período (Mes+Año) y el importe.
select top 1 Socios.Nombres, Socios.Apellidos, Pagos.Mes, Pagos.Anio as "Año", Pagos.Importe
from Socios
inner join Pagos on (Socios.Legajo = Pagos.Legajo)
order by Pagos.Importe desc

-- 15) Listar el nombre de la actividad más cara que posea algún becado.
select top 1 Actividades.Nombre from Actividades
inner join Inscripciones on (Actividades.ID = Inscripciones.IDActividad)
where Inscripciones.Becado = 1
order by Actividades.Costo desc

-- 16) Listar nombre y apellido del socio, nombre de la actividad y la cantidad de días transcurridos
-- desde que se inscribió a dicha actividad. Ordenarlo por cantidad de días de manera descendente.
select Socios.Nombres, Socios.Apellidos, Actividades.Nombre as "Actividad", DATEDIFF(DAY, Inscripciones.FechaInscripcion, GETDATE()) as "Dias Transcurridos"
from Socios
inner join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
inner join Actividades on (Inscripciones.IDActividad = Actividades.ID)
order by 4 desc
