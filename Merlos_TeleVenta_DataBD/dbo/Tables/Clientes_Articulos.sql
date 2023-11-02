CREATE TABLE [dbo].[Clientes_Articulos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Cliente] [varchar](50) NOT NULL,
	[Articulo] [varchar](50) NOT NULL,
	[Descripcion] [nvarchar](1000) NULL,
	[IncluirExcluir] [smallint] NULL,
	[Usuario] [nvarchar](100) NULL,
	[usuarioSQL] [nvarchar](100) NULL,
	[FechaInsert] [datetime] NULL,
	[FechaUpdate] [datetime] NULL,
 CONSTRAINT [PK_Clientes_Articulos] PRIMARY KEY CLUSTERED 
(
	[Cliente] ASC,
	[Articulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Clientes_Articulos] ADD  CONSTRAINT [DF_Clientes_Articulos_IncluirExcluir]  DEFAULT ((0)) FOR [IncluirExcluir]
GO

ALTER TABLE [dbo].[Clientes_Articulos] ADD  CONSTRAINT [DF_Clientes_Articulos_usuarioSQL]  DEFAULT (suser_sname()) FOR [usuarioSQL]
GO

ALTER TABLE [dbo].[Clientes_Articulos] ADD  CONSTRAINT [DF_Clientes_Articulos_FechaInsert]  DEFAULT (getdate()) FOR [FechaInsert]
GO
