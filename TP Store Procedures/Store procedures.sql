--- Procedimientos almacenados

-- 1) Hacer un procedimiento almacenado que permita listar la información de
-- todas las actividades
create procedure SP_Actividades
as
begin
	select * from Actividades
end
	GO
exec SP_Actividades
GO
-- 2) Hacer un procedimiento almacenado que permita listar la información de
-- todas las actividades a partir del Apto médico. El procedimiento recibirá
-- un 1 para listar las actividades que requieren apto médico o un 0
-- para las que no requieren apto médico.
create procedure SP_ActividadesAptoMedico(
	@aptoMedico bit
)
as
begin
	select * from Actividades where AptoMedico = @aptoMedico
end
GO
exec SP_ActividadesAptoMedico 0
GO

-- 3) Hacer un procedimiento almacenado que reciba un legajo de socio y
-- liste todas las actividades que realiza ese socio.
create procedure SP_ActividadesSocio
(
	@legajo bigint
) as
begin
	select Inscripciones.Legajo, Actividades.Nombre from Inscripciones 
	inner join Actividades on (Inscripciones.IDActividad = Actividades.ID)
	where Inscripciones.Legajo = 1000
end
GO
exec SP_ActividadesSocio 1000
GO

-- 4) Hacer un procedimiento almacenado que reciba un legajo de socio y un
-- número de año y liste todos los pagos realizados por ese socio en ese año.
create procedure SP_SocioPagosAnio
(
	@legajo bigint,
	@anio int
) as
begin
	select * from Pagos
	inner join Socios on (Pagos.Legajo = Socios.Legajo)
	where Pagos.Legajo = @legajo and Pagos.Anio = @anio
end
GO
exec SP_SocioPagosAnio 2000, 2019
GO

-- 5) Hacer un procedimiento almacenado que reciba un legajo de socio y un
-- número de año y liste el total abonado por ese socio a lo largo del año.
create procedure SP_PagosSocioAnio
(
	@legajo bigint,
	@anio int
) as
begin
	select sum( Pagos.Importe ) as 'Importe' from Pagos
	inner join Socios on (Pagos.Legajo = Socios.Legajo)
	where Socios.Legajo = @legajo and Pagos.Anio = @anio
end
GO
exec SP_PagosSocioAnio 1000, 2019
GO

-- 6) Hacer un procedimiento almacenado que reciba un legajo de socio y un
-- código de actividad y beque a dicho socio en esa actividad. El procedimiento
-- debe contemplar dos situaciones:
-- A) El socio ya se encuentre inscripto a la actividad, por lo tanto, se modifica
-- su estado de Becado.
-- B) El socio no se encuentra inscripto a la actividad, por lo tanto, se lo
-- inscribe becado a la actividad.
create procedure SP_BecarLegajoActividad
(
	@legajo bigint,
	@idActividad bigint
) as
begin
	declare @inscripto smallint
	
	select @inscripto= count(*) from Inscripciones 
	where Inscripciones.Legajo = @legajo and Inscripciones.IDActividad = @idActividad

	if @inscripto = 1
		begin
			update Inscripciones
			set Inscripciones.Becado = 1
			where Inscripciones.Legajo = @legajo and Inscripciones.IDActividad = @idActividad
		end
	else
		begin
			insert into Inscripciones values (@legajo, @idActividad, 1, GETDATE())
		end
end
GO
exec SP_BecarLegajoActividad 1000, 4
GO

-- 7) Hacer un procedimiento almacenado que permita inscribir un socio a una
-- actividad. Se debe recibir el Legajo, el código de actividad y el estado
-- de beca. El procedimiento debe asegurar que un socio no pueda estar becado
-- en más de dos actividades a la vez. En caso de que esto ocurra, listar un
-- mensaje de error y no registrar la inscripción. De lo contrario, inscribir al socio
create procedure SP_InscribirSocioActividad
(
	@legajo bigint,
	@idActividad bigint,
	@becado bit
) as
begin
	declare @becas smallint
	select @becas = count(*) from Inscripciones
	where Legajo = @legajo and Becado = 1

	if @becas >= 2 and @becado = 1
		begin
			RAISERROR('No se puede becar', 16, 1)
		end
	else
		begin
			insert into Inscripciones values (@legajo, @idActividad, @becado, GETDATE())
		end
end
GO
exec SP_InscribirSocioActividad 2000, 1, 1
GO

-- 8) Hacer un procedimiento almacenado que permita registrar un pago de un socio.
-- El procedimiento debe recibir el Legajo, mes y año y calcular el importe del
-- pago. Para ello deberá sumar el costo de todas las actividades que realice el
-- socio en las que no se encuentre becado. Tener en cuenta que el importe puede
-- ser cero.
 
create procedure SP_RegistraPago
(
	@legajo bigint,
	@mes smallint,
	@anio smallint
) as
begin
	declare @totalPagos money
	select @totalPagos = sum(Actividades.Costo) from Inscripciones
	inner join Actividades on (Inscripciones.IDActividad = Actividades.ID)
	where Legajo = @legajo and Becado = 0
	insert into Pagos values (@legajo, @mes, @anio, getdate(), 1, @totalPagos)
end
GO
exec SP_RegistraPago 1000, 3, 2020
GO


-- 9) Hacer un procedimiento almacenado que permita eliminar un socio. Para ello
-- debe realizar, además, la eliminación de: 
-- Todos los pagos e inscripciones del socio.
create procedure SP_EliminaSocio
(
	@legajo bigint
) as
begin
	delete from Pagos where Pagos.Legajo = @legajo
	delete from Inscripciones where Inscripciones.Legajo = @legajo
	delete from Socios where Socios.Legajo = @legajo
end
GO
exec SP_EliminaSocio 1000
GO

-- 10) Hacer un procedimiento almacenado que reciba un valor Decimal(5, 2) y
-- permita aumentar porcentualmente el costo de todas las actividades 
-- a partir de dicho valor. Generar una excepción si el valor 
-- recibido no es positivo. 
create procedure SP_AumentarCostoActividades
(
	@porcentaje decimal(5,2)
)
as
begin
	if @porcentaje < 0
		begin
			raiserror('Valor erroneo',16,1)
		end
	update Actividades set Costo = Costo + (Costo * @porcentaje / 100)
end
GO
select * from Actividades
exec SP_AumentarCostoActividades 50.0
select * from Actividades
GO