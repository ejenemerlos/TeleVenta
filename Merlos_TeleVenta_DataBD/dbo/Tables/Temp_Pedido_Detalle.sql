﻿CREATE TABLE [dbo].[Temp_Pedido_Detalle](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[jsId] [varchar](50) NULL,
	[IdTransaccion] [varchar](50) NULL,
	[Ejercicio] [char](4) NULL,
	[IdTeleventa] [varchar](50) NULL,
	[IdPedido] [varchar](50) NULL,
	[empresa] [char](2) NULL,
	[numero] [varchar](50) NULL,
	[letra] [char](2) NULL,
	[linea] [smallint] NULL,
	[cliente] [varchar](50) NULL,
	[articulo] [varchar](50) NULL,
	[descrip] [varchar](100) NULL,
	[cajas] [numeric](10, 2) NULL,
	[unidades] [numeric](15, 6) NULL,
	[peso] [numeric](20, 4) NULL,
	[volumen] [varchar](100) NULL,
	[dto1] [numeric](20, 2) NULL,
	[dto2] [numeric](20, 2) NULL,
	[dto3] [numeric](20, 2) NULL,
	[precio] [numeric](15, 6) NULL,
	[importeiva] [numeric](20, 2) NULL,
	[incidencia] [char](2) NULL,
	[incidencia_descrip] [nvarchar](100) NULL,
	[observacion] [nvarchar](100) NULL,
	[UserLogin] [varchar](50) NULL,
	[UserId] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[UserReference] [varchar](50) NULL,
	[estado] [smallint] NOT NULL DEFAULT ((0)),
	[FechaInsertUpdate] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY]
GO