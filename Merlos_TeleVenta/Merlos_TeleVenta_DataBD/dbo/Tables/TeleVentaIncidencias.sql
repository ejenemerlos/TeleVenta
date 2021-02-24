
CREATE TABLE [dbo].[TeleVentaIncidencias](
	[id] [varchar](50) NULL,
	[tipo] [varchar](50) NULL,
	[incidencia] [varchar](50) NULL,
	[cliente] [varchar](50) NULL,
	[idpedido] [varchar](50) NULL,
	[articulo] [varchar](50) NULL,
	[observaciones] [varchar](1000) NULL,
	[FechaInsertUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TeleVentaIncidencias] ADD  CONSTRAINT [DF_TeleVentaIncidencias_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO

