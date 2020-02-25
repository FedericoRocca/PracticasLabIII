use master;
GO

drop database Clubes;
GO

create database Clubes;
GO

USE Clubes;
GO

create table Provincias
(
    id bigint not null primary key identity (1,1),
    nombre varchar(100) not null
);
GO

create table Localidades
(
    id bigint not null primary key identity (1,1),
    codPost int not null,
    nombre varchar(100) not null,
    idProvincia bigint not null foreign key (idProvincia) references Provincias(id),
    unique(codPost)
);
GO

create table Sedes
(
    id bigint not null primary key identity (1,1),
    nombre varchar(100) not null,
    idLocalidad bigint not null foreign key (idLocalidad) references Localidades(id),
    direccion varchar(100) not null,
    telefono int null check (telefono > 0),
    mail varchar(100) null,
    unique (idLocalidad, direccion)
);
GO

create table Actividades
(
    id bigint not null primary key identity (1,1),
    nombre varchar(100) not null,
    costo money not null check (costo > 0),
    aptoMedico bit not null,
    idSede bigint not null foreign key (idSede) references Sedes(id),
    unique(nombre, costo, aptoMedico, idSede)
);
GO

create table Socios
(
    id bigint not null primary key identity (1,1),
    nombre varchar(100) not null,
    apeliido varchar(100) not null,
    fecNac date not null check(fecNac < '01/01/2010'),
    genero char null,
    legajo int not null,
    unique(Legajo)
);
GO

create table ActividadesPorSocio
(
    id bigint not null primary key identity (1,1),
    idSocio bigint not null foreign key (idSocio) references Socios(id),
    idActividad bigint not null foreign key (idActividad) references Actividades(id),
    becado bit not null,
    unique(idSocio, idActividad)
);
GO

USE [Clubes]
GO
SET IDENTITY_INSERT [dbo].[Provincias] ON
GO
INSERT [dbo].[Provincias] ([id], [nombre]) VALUES (1, N'Buenos Aires')
GO
INSERT [dbo].[Provincias] ([id], [nombre]) VALUES (2, N'Capital Federal')
GO
SET IDENTITY_INSERT [dbo].[Provincias] OFF
GO
SET IDENTITY_INSERT [dbo].[Localidades] ON
GO
INSERT [dbo].[Localidades] ([id], [codPost], [nombre], [idProvincia]) VALUES (1, 1111, N'San Fernando', 1)
GO
INSERT [dbo].[Localidades] ([id], [codPost], [nombre], [idProvincia]) VALUES (2, 2222, N'Lanús', 2)
GO
INSERT [dbo].[Localidades] ([id], [codPost], [nombre], [idProvincia]) VALUES (3, 3333, N'Tigre', 1)
GO
INSERT [dbo].[Localidades] ([id], [codPost], [nombre], [idProvincia]) VALUES (4, 4444, N'Pilar', 1)
GO
SET IDENTITY_INSERT [dbo].[Localidades] OFF
GO
SET IDENTITY_INSERT [dbo].[Sedes] ON
GO
INSERT [dbo].[Sedes] ([id], [nombre], [idLocalidad], [direccion], [telefono], [mail]) VALUES (1, N'Norte', 1, N'Presidente Simón 4400', 14141414, N'norte@lab3.com.ar')
GO
INSERT [dbo].[Sedes] ([id], [nombre], [idLocalidad], [direccion], [telefono], [mail]) VALUES (2, N'Sur', 2, N'Dr Kloster 1080', 15151515, N'sur@lab3.com.ar')
GO
INSERT [dbo].[Sedes] ([id], [nombre], [idLocalidad], [direccion], [telefono], [mail]) VALUES (3, N'Microestadio', 3, N'Virrey Calabuig 1350', NULL, N'micro@lab3.com.ar')
GO
INSERT [dbo].[Sedes] ([id], [nombre], [idLocalidad], [direccion], [telefono], [mail]) VALUES (4, N'Microestadio II', 4, N'Almirante de Amos 3200', 13131313, NULL)
GO
INSERT [dbo].[Sedes] ([id], [nombre], [idLocalidad], [direccion], [telefono], [mail]) VALUES (5, N'Norte II', 1, N'Av. Codeblocks 1111', 90909090, NULL)
GO
SET IDENTITY_INSERT [dbo].[Sedes] OFF
GO
SET IDENTITY_INSERT [dbo].[Actividades] ON
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (1, N'Ajedrez', 250.0000, 0, 1)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (10, N'Doom', 500.0000, 0, 2)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (8, N'Fortnite', 1850.0000, 0, 1)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (4, N'Fútbol', 500.0000, 1, 4)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (3, N'Handball', 450.0000, 1, 3)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (5, N'Natación', 1850.0000, 1, 4)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (9, N'Programación', 1400.0000, 0, 1)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (7, N'Taller literario', 100.0000, 0, 1)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (2, N'Voley', 450.0000, 1, 3)
GO
INSERT [dbo].[Actividades] ([id], [nombre], [costo], [aptoMedico], [idSede]) VALUES (6, N'Yoga', 500.0000, 1, 2)
GO
SET IDENTITY_INSERT [dbo].[Actividades] OFF
GO
SET IDENTITY_INSERT [dbo].[Socios] ON
GO
INSERT [dbo].[Socios] ([id], [nombre], [apeliido], [fecNac], [genero], [legajo]) VALUES (1, N'Javier', N'Angeleli', CAST(N'1990-01-01' AS Date), N'M', 1000)
GO
INSERT [dbo].[Socios] ([id], [nombre], [apeliido], [fecNac], [genero], [legajo]) VALUES (2, N'Belen', N'Baires', CAST(N'1998-02-02' AS Date), N'M', 2000)
GO
INSERT [dbo].[Socios] ([id], [nombre], [apeliido], [fecNac], [genero], [legajo]) VALUES (3, N'Juan', N'Corrionero', CAST(N'2004-03-03' AS Date), N'M', 3000)
GO
INSERT [dbo].[Socios] ([id], [nombre], [apeliido], [fecNac], [genero], [legajo]) VALUES (4, N'Oriana', N'Garcia', CAST(N'1986-04-04' AS Date), N'F', 5000)
GO
INSERT [dbo].[Socios] ([id], [nombre], [apeliido], [fecNac], [genero], [legajo]) VALUES (5, N'Kevin', N'Kusters', CAST(N'2000-05-05' AS Date), N'M', 6000)
GO
INSERT [dbo].[Socios] ([id], [nombre], [apeliido], [fecNac], [genero], [legajo]) VALUES (6, N'Ignacio', N'Lacioppa', CAST(N'2000-06-06' AS Date), N'M', 7000)
GO
INSERT [dbo].[Socios] ([id], [nombre], [apeliido], [fecNac], [genero], [legajo]) VALUES (7, N'Federico', N'Rocca', CAST(N'1960-07-07' AS Date), N'M', 8000)
GO
INSERT [dbo].[Socios] ([id], [nombre], [apeliido], [fecNac], [genero], [legajo]) VALUES (8, N'Magalí', N'Albornoz', CAST(N'1990-08-08' AS Date), N'F', 9000)
GO
SET IDENTITY_INSERT [dbo].[Socios] OFF
GO
SET IDENTITY_INSERT [dbo].[ActividadesPorSocio] ON
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (1, 4, 1, 0)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (2, 4, 3, 0)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (3, 4, 2, 0)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (4, 6, 1, 0)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (5, 7, 3, 0)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (6, 7, 2, 1)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (7, 4, 4, 1)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (8, 5, 1, 0)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (9, 5, 3, 1)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (10, 5, 2, 0)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (11, 6, 4, 0)
GO
INSERT [dbo].[ActividadesPorSocio] ([id], [idSocio], [idActividad], [becado]) VALUES (12, 7, 10, 1)
GO
SET IDENTITY_INSERT [dbo].[ActividadesPorSocio] OFF
GO

