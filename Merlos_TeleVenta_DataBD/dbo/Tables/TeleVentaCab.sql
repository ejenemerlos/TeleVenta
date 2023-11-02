CREATE TABLE [dbo].[TeleVentaCab](
	[id] [varchar](50) NULL,
	[usuario] [varchar](20) NULL,
	[fecha] [varchar](5000) NULL,
	[nombre] [varchar](100) NULL,
	[clientes] [int] NULL,
	[llamadas] [int] NULL,
	[pedidos] [int] NULL,
	[subtotal] [numeric](15, 6) NULL,
	[importe] [numeric](15, 6) NULL,
	[Terminado] [datetime] NULL,
	[FechaInsertUpdate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TeleVentaCab] ADD  CONSTRAINT [DF_TeleVentaCab_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO