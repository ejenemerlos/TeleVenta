CREATE TABLE [dbo].[Pedidos_Contactos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[IDPEDIDO] [varchar](50) NULL,
	[Cliente] [varchar](20) NULL,
	[Contacto] [int] NULL,
	[FechaInsertUpdate] [datetime] NULL,
	CONSTRAINT [PK_Pedidos_Contactos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pedidos_Contactos] ADD  CONSTRAINT [DF_Pedidos_Contactos_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
