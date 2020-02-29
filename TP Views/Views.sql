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
-- el mes y a�o del pago y el importe del pago

-- 5) Hacer una vista que permita ver para cada socio el apellido y nombre,
-- el g�nero, la cantidad de pagos realizados y el importe total en concepto de
-- pagos.

--- Procedimientos almacenados

-- 1) Hacer un procedimiento almacenado que permita listar la informaci�n de
-- todas las actividades

-- 2) Hacer un procedimiento almacenado que permita listar la informaci�n de
-- todas las actividades a partir del Apto m�dico. El procedimiento recibir�
-- un 1 para listar las actividades que requieren apto m�dico o un 0
-- para las que no requieren apto m�dico.

-- 3) Hacer un procedimiento almacenado que reciba un legajo de socio y
-- liste todas las actividades que realiza ese socio.
-- 4) Hacer un procedimiento almacenado que reciba un legajo de socio y un
-- n�mero de a�o y liste todos los pagos realizados por ese socio en ese a�o.

-- 5) Hacer un procedimiento almacenado que reciba un legajo de socio y un
-- n�mero de a�o y liste el total abonado por ese socio a lo largo del a�o.

-- 6) Hacer un procedimiento almacenado que reciba un legajo de socio y un
-- c�digo de actividad y beque a dicho socio en esa actividad. El procedimiento
-- debe contemplar dos situaciones:
-- A) El socio ya se encuentre inscripto a la actividad, por lo tanto, se modifica
-- su estado de Becado.
-- B) El socio no se encuentra inscripto a la actividad, por lo tanto, se lo
-- inscribe becado a la actividad.

-- 7) Hacer un procedimiento almacenado que permita inscribir un socio a una
-- actividad. Se debe recibir el Legajo, el c�digo de actividad y el estado
-- de beca. El procedimiento debe asegurar que un socio no pueda estar becado
-- en m�s de dos actividades a la vez. En caso de que esto ocurra, listar un
-- mensaje de error y no registrar la inscripci�n. De lo contrario, inscribir al socio

-- 8) Hacer un procedimiento almacenado que permita registrar un pago de un socio.
-- El procedimiento debe recibir el Legajo, mes y a�o y calcular el importe del
-- pago. Para ello deber� sumar el costo de todas las actividades que realice el
-- socio en las que no se encuentre becado. Tener en cuenta que el importe puede
-- ser cero.

-- 9) Hacer un procedimiento almacenado que permita eliminar un socio. Para ello
-- debe realizar, adem�s, la eliminaci�n de: 
-- Todos los pagos e inscripciones del socio.

-- 10) Hacer un procedimiento almacenado que reciba un valor Decimal(5, 2) y
-- permita aumentar porcentualmente el costo de todas las actividades 
-- a partir de dicho valor. Generar una excepci�n si el valor 
-- recibido no es positivo. 