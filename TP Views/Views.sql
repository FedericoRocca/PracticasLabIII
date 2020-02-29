-- Vistas

-- 1) Hacer una vista que permita ver para cada socio los nombres de las actividades
-- y sedes donde las realiza.
create view VW_SociosActividadesSedes as
	select Socios.Nombres, Socios.Apellidos, Actividades.Nombre as 'Actividad', Sedes.Nombre as 'Sede' from Socios
	inner join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
	inner join Actividades on (Inscripciones.IDActividad = Actividades.ID)
	inner join Sedes on (Actividades.IDSede = Sedes.ID)
go
select * from VW_SociosActividadesSedes
GO

-- 2) Hacer una vista que permita ver para cada actividad, el nombre y
-- la cantidad de socios inscriptos que posee.
create view VW_ActividadesSociosInscriptos as
	select Actividades.Nombre, count(distinct Inscripciones.Legajo) as 'Cantidad de socios inscriptos' from Actividades
	left join Inscripciones on (Actividades.ID = Inscripciones.IDActividad)
	group by Actividades.Nombre
GO
select * from VW_ActividadesSociosInscriptos
GO


-- 3) Hacer una vista que permita ver para cada socio, el apellido, nombres y la
-- cantidad de actividades en la que se encuentre becado.
create view VW_SociosBecas as
select Socios.Apellidos, Socios.Nombres, count(Inscripciones.IDInscripcion) as 'Becas' from Socios
inner join Inscripciones on (Socios.Legajo = Inscripciones.Legajo)
where Inscripciones.Becado = 1
group by Socios.Apellidos, Socios.Nombres
GO
select * from VW_SociosBecas
GO
-- 4) Hacer una vista que permita ver para cada socio, el apellido y nombre,
-- el mes y año del pago y el importe del pago
create view VW_SociosPagos as
select Socios.Apellidos, Socios.Nombres, Pagos.Anio as 'Año', Pagos.Mes, Pagos.Importe from Pagos
inner join Socios on (Pagos.Legajo = Socios.Legajo)
GO
select * from VW_SociosPagos
GO

-- 5) Hacer una vista que permita ver para cada socio el apellido y nombre,
-- el género, la cantidad de pagos realizados y el importe total en concepto de
-- pagos.
create view VW_SociosPagosImportes as 
select Socios.Apellidos, Socios.Nombres, Socios.Genero, count(Pagos.IDPago) as 'Cantidad de pagos', sum(Pagos.Importe) as 'Importe de pagos' from Pagos
inner join Socios on (Pagos.Legajo = Socios.Legajo)
group by Socios.Apellidos, Socios.Nombres, Socios.Genero
GO
select * from VW_SociosPagosImportes
GO