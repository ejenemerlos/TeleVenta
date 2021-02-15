CREATE TABLE [dbo].[AlbaranVentaFirmas](
	[Id] [uniqueidentifier] NOT NULL,
	[IdPedido] [varchar](50) NOT NULL,
	[IdAlbaran] [varchar](50) NULL,
	[Nombre] [varchar](100) NULL,
	[Cargo] [varchar](50) NULL,
	[DNI] [varchar](20) NULL,
	[Firma] [varchar](max) NULL,
	[FechaInsertUpdate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AlbaranVentaFirmas] ADD  CONSTRAINT [DF_AlbaranVentaFirmas_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[AlbaranVentaFirmas] ADD  CONSTRAINT [DF_AlbaranVentaFirmas_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
