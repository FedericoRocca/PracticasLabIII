-- 1 - Elaborar una vista que permita conocer para cada cliente: el apellido y nombres, los números de
-- cuenta, el saldo de la cuenta, la cantidad de movimientos realizados por cada cuenta y el saldo
-- acumulado entre todas las cuentas de cada cliente.
select CLIENTES.APELLIDO, CLIENTES.NOMBRE, CUENTAS.IDCUENTA ,CUENTAS.SALDO, count(MOVIMIENTOS.IDMOVIMIENTO) as 'Saldo', SUM(CUENTAS.SALDO) as 'Acumulado'
from CLIENTES
inner join CUENTAS on (CLIENTES.IDCLIENTE = CUENTAS.IDCLIENTE)
left join MOVIMIENTOS on (CUENTAS.IDCUENTA = MOVIMIENTOS.IDMOVIMIENTO)
group by CLIENTES.APELLIDO, CLIENTES.NOMBRE, CUENTAS.IDCUENTA, CUENTAS.SALDO
GO
-- 2 - Elaborar un procedimiento almacenado que permita crear una cuenta. El procedimiento debe recibir:
-- @IDCliente, @Tipo y @Limite. Debe permitir cumplir la siguiente condición:
-- Los tipos de cuenta pueden ser: CA - Caja de ahorro y CC - Cuenta corriente. De lo contrario, impedir el
-- ingreso.
-- - Si el tipo es Caja de Ahorro entonces el límite de la cuenta debe ser obligatoriamente cero.
-- - Si el tipo es Cuenta corriente entonces el límite puede ser cualquier número mayor o igual que
-- cero. Tener en cuenta que en el límite siempre se almacena con un valor negativo.
-- - El saldo siempre será cero y el estado siempre será uno.
-- Ejemplo:
-- EXEC SP_NuevaCuenta 1, 'CC', 5000
-- Deberá registrar lo siguiente:
-- INSERT INTO Cuentas (IDCliente, Tipo, Limite, Saldo, Estado) VALUES (1, 'CC', -5000, 0, 1)
-- En cambio:
-- EXEC SP_NuevaCuenta 1, 'CA', 5000
-- Deberá registrar lo siguiente:
-- INSERT INTO Cuentas (IDCliente, Tipo, Limite, Saldo, Estado) VALUES (1, 'CA', 0, 0, 1)
create procedure SP_CrearCuenta
(
	@idCliente bigint,
	@tipo varchar(2),
	@limite money
) as 
begin
	if @tipo != 'CC' and @tipo != 'CA'
		begin
			raiserror('Cuenta inválida', 16, 1)
		end

	if @tipo = 'CA'
		begin
			set @limite = 0
		end
	else
		begin
			if @limite < 0
				begin
					raiserror('Limite erroneo',16,1)
				end
		end

		insert into CUENTAS values (@idCliente, @tipo, -@limite, 0, 1)
end
GO
exec SP_CrearCuenta 1, CA, 5000
exec SP_CrearCuenta 1, CC, 5000
GO

-- 3 - Realizar un trigger que al registrar una nueva cuenta le sea otorgada una tarjeta de débito. La misma
-- se identifica con un valor 'D' en el Tipo de la tarjeta.
create trigger TR_AltaTarjetaDebitoEnCuenta on CUENTAS
after insert
as
begin
	declare @idCuenta bigint
	select @idCuenta = IDCUENTA from inserted
	insert into TARJETAS values (@idCuenta, 'D', 0)
end
GO
exec SP_CrearCuenta 1, CA, 5000
GO

-- 4 - Realizar un trigger que al registrar un nuevo usuario le sea otorgada una Caja de Ahorro nueva.
create trigger SP_CajaAhorroEnAltaUsuario
on CLIENTES
after insert
as
begin
	declare @idCliente bigint
	select @idCliente = inserted.IDCLIENTE from inserted
	exec SP_CrearCuenta @idCliente, 'CA', 0000
end
GO
insert into CLIENTES values (5, 'Rocca', 'Federico', 1)
GO

-- 5 - Realizar un trigger que al eliminar un usuario realice la baja lógica del mismo. Si se elimina un usuario
-- que ya se encuentra dado de baja lógica y dicho usuario no registra ni cuentas ni tarjetas, proceder a la
-- baja física del usuario.
create trigger TR_BajaClientes on CLIENTES
instead of delete
as
begin
	declare @idCliente bigint
	select @idCliente =  deleted.IDCLIENTE from deleted
	
	declare @estado bit
	select @estado =  deleted.ESTADO from deleted
	
	if @estado = 0
		begin
			declare @tarjetasCount bigint
			select @tarjetasCount = count(TARJETAS.IDTARJETA) from TARJETAS
			inner join CUENTAS on (TARJETAS.IDCUENTA = CUENTAS.IDCUENTA)
			where CUENTAS.IDCLIENTE = @idCliente

			declare @cuentasCount bigint
			select @cuentasCount = count(CUENTAS.IDCUENTA) from CUENTAS
			where CUENTAS.IDCLIENTE = @idCliente

			if @cuentasCount = 0 and @tarjetasCount = 0
				begin
					delete from CLIENTES where CLIENTES.IDCLIENTE = @idCliente
				end
		end
	else
		begin
			update CLIENTES set ESTADO = 0 where CLIENTES.IDCLIENTE = @idCliente
		end

end
GO
select * from CLIENTES
left join CUENTAS on (CLIENTES.IDCLIENTE = CUENTAS.IDCLIENTE)
left join TARJETAS on (CUENTAS.IDCUENTA = TARJETAS.IDCUENTA)
delete from CLIENTES where CLIENTES.IDCLIENTE = 5
GO

-- 6 - Realizar un trigger que al registrar un nuevo movimiento, actualice el saldo de la cuenta. Deberá
-- acreditar o debitar dinero en la cuenta dependiendo del tipo de movimiento ('D' - Débito y 'C' - Crédito). Se
-- deberá:
-- - Registrar el movimiento
-- - Actualizar el saldo de la cuenta
drop trigger TR_NuevoMovimiento
create trigger TR_NuevoMovimiento on MOVIMIENTOS
instead of insert
as
begin
	declare @idCuenta bigint
	select @idCuenta = inserted.IDCUENTA from inserted

	declare @importe money
	select @importe = inserted.IMPORTE from inserted

	declare @saldoCuenta money
	select @saldoCuenta = CUENTAS.SALDO from CUENTAS where CUENTAS.IDCUENTA = @idCuenta

	declare @tipoMovimiento char
	select @tipoMovimiento = inserted.TIPO from inserted

	if @importe > @saldoCuenta and @tipoMovimiento = 'D'
		begin
			raiserror('Sin saldo suficiente', 16, 1)
		end
	else
		begin

			declare @fecha smalldatetime
			select @fecha = inserted.FECHA from inserted

			declare @estado char
			select @estado = inserted.ESTADO from inserted

			insert into MOVIMIENTOS values (@idCuenta, @importe, @tipoMovimiento, @fecha, @estado )

			if @tipoMovimiento = 'D'
				begin
					update CUENTAS set SALDO = SALDO - @importe where CUENTAS.IDCUENTA = @idCuenta
				end
			else
				begin
					update CUENTAS set SALDO = SALDO + @importe where CUENTAS.IDCUENTA = @idCuenta
				end
		end
end
GO

select * from CUENTAS where CUENTAS.IDCUENTA = 1
select * from MOVIMIENTOS
insert into MOVIMIENTOS values (1, 1000, 'D', GETDATE(), 1)
GO

-- 7 - Realizar un trigger que al registrar una nueva transferencia, registre los movimientos y actualice los
-- saldos de las cuenta. Deberá verificar que las cuentas de origen y destino sean distintas. Se deberá:
-- - Registrar la transferencia
-- - Registrar el movimiento de la cuenta de origen
-- - Registrar el movimiento de la cuenta de destino
-- NOTA: La acción debería generar una reacción en cadena si se realizó correctamente el Trigger de (6).
create trigger TR_NuevaTransferencia on TRANSFERENCIAS
instead of insert
as
begin
	select * from TRANSFERENCIAS	
	declare @cuentaOrigen bigint
	declare @cuentaDestino bigint
	declare @importe money
	declare @fecha smalldatetime
	declare @estado bit

	select @cuentaOrigen = inserted.ORIGEN from inserted
	select @cuentaDestino = inserted.DESTINO from inserted
	select @importe = inserted.IMPORTE from inserted
	select @fecha = inserted.FECHA from inserted
	select @estado = inserted.ESTADO from inserted

	if @cuentaDestino = @cuentaOrigen
	begin
		raiserror('Las cuentas origen y destino son las mismas', 16,1);
		return
	end

	declare @saldoOrigen money
	select @saldoOrigen = CUENTAS.SALDO from CUENTAS where IDCUENTA = @cuentaOrigen
	if @saldoOrigen <= 0 or @saldoOrigen < @importe
		begin
			raiserror('El saldo es insuficiente',16 ,1)
			return
		end

	insert into MOVIMIENTOS values (@cuentaOrigen, @importe, 'D', @fecha, @estado)
	insert into MOVIMIENTOS values (@cuentaDestino, @importe, 'C', @fecha, @estado)
	insert into TRANSFERENCIAS values (@cuentaOrigen, @cuentaDestino, @importe, @fecha, @estado)

end
GO
select * from TRANSFERENCIAS
select * from CUENTAS
select * from MOVIMIENTOS
insert into TRANSFERENCIAS values (1, 2, 1000, GETDATE(), 1)