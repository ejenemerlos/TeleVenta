CREATE TABLE [dbo].[inci_CliArt](
	[empresa] [char](2) NOT NULL,
	[fecha] [varchar](10) NOT NULL,
	[hora] [char](5) NOT NULL,
	[nombreTV] [varchar](100) NULL,
	[idpedido] [varchar](50) NULL,
	[cliente] [char](20) NOT NULL,
	[articulo] [char](25) NOT NULL,
	[incidencia] [char](2) NULL,
	[descripcion] [char](50) NULL,
	[observaciones] [nvarchar](1000) NULL
) ON [PRIMARY]
GO