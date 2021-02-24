CREATE TABLE [dbo].[TeleVentaFiltros](
	[id] [varchar](50) NOT NULL,
	[tipo] [varchar](50) NULL,
	[valor] [varchar](100) NULL,
	[FechaInsertUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TeleVentaFiltros] ADD  CONSTRAINT [DF_TeleVentaFiltros_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO

