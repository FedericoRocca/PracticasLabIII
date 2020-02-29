create database Pizzeria
go

use Pizzeria
go

create table Pizzas
(
	id bigint not null primary key identity(1,1),
	nombre varchar(100) not null,
	precio money not null check(precio > 0)
)
GO

create table tiposIngredientes
(
	id bigint not null primary key identity(1,1),
	nombre varchar(100) not null
)

create table Ingredientes
(
	id bigint not null primary key identity(1,1),
	nombre varchar(100) not null,
	tipoIngrediente bigint not null foreign key (tipoIngrediente) references tiposIngredientes(id),
)
GO

create table Recetas
(
	idPizza bigint not null foreign key (idPizza) references Pizzas(id),
	idIngrediente bigint not null foreign key (idIngrediente) references Ingredientes(id),
	cantidad decimal(6,2) not null,
	primary key(idPizza, idIngrediente)
)
GO