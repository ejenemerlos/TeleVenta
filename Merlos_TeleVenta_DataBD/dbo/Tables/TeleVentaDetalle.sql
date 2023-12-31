﻿CREATE TABLE [dbo].[TeleVentaDetalle](
	[id] [varchar](50) NULL,
	[cliente] [varchar](50) NULL,
	[horario] [varchar](20) NULL,
	[idpedido] [varchar](50) NULL,
	[pedido] [varchar](50) NULL,
	[subtotal] NUMERIC(15, 6) NULL DEFAULT 0,
	[importe] NUMERIC(15, 6) NULL DEFAULT 0,
	[serie] [varchar](2) NULL,
	[completado] [int] NULL,
	[fechaLlamada] varchar(10) NULL,
	[IdDoc] [int] IDENTITY(1,1) NOT NULL,
	[FechaInsertUpdate] [datetime] NOT NULL    
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TeleVentaDetalle] ADD  CONSTRAINT [DF_TeleVentaDetalle_completado]  DEFAULT ((0)) FOR [completado]
GO

ALTER TABLE [dbo].[TeleVentaDetalle] ADD  CONSTRAINT [DF_TeleVentaDetalle_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO

