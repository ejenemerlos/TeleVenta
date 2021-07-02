CREATE TABLE [dbo].[TeleVentaCab](
	[id] [varchar](50) NULL,
	[usuario] [varchar](20) NULL,
	[fecha] [varchar](10) NULL,
	[nombre] [varchar](100) NULL,
	[clientes] [int] NULL,
	[llamadas] [int] NULL,
	[pedidos] [int] NULL,
	[importe] [numeric](15, 6) NULL,
	[FechaInsertUpdate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TeleVentaCab] ADD  CONSTRAINT [DF_TeleVentaCab_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO