﻿CREATE TABLE [dbo].[Temp_Pedido_Cabecera](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTransaccion] [varchar](50) NULL,
	[IdPedido] [varchar](50) NULL,
	[usuario] [varchar](50) NULL,
	[empresa] [char](2) NULL,
	[numero] [char](10) NULL,
	[fecha] [smalldatetime] NULL,
	[cliente] [char](10) NULL,
	[env_cli] [smallint] NULL,
	[entrega] [smalldatetime] NULL,
	[vendedor] [varchar](20) NULL,
	[ruta] [varchar](20) NULL,
	[pronto] [numeric](20, 4) NULL,
	[iva_inc] [bit] NULL,
	[divisa] [char](3) NULL,
	[cambio] [numeric](20, 6) NULL,
	[fpag] [char](2) NULL,
	[letra] [char](2) NULL,
	[hora] [datetime] NULL,
	[almacen] [char](2) NULL,
	[observacio] [varchar](max) NULL,
	[impreso] [bit] NULL,
	[comms] [bit] NULL,
	[noCobrarPortes] [char](1) NULL,
	[verificarPedido] [char](1) NULL,
	[UserLogin] [varchar](50) NULL,
	[UserId] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[UserReference] [varchar](50) NULL,
	[estado] [smallint] NOT NULL DEFAULT ((0)),
	[FechaInsertUpdate] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO