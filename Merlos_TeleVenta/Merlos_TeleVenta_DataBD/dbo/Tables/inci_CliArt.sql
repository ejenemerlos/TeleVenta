CREATE TABLE [dbo].[inci_CliArt](
	[empresa] [char](2) NOT NULL,
	[cliente] [char](20) NOT NULL,
	[fecha] [varchar](10) NOT NULL,
	[articulo] [char](25) NOT NULL,
	[incidencia] [char](2) NULL,
	[descripcion] [char](50) NULL,
	[hora] [char](5) NOT NULL,
	[observaciones] [nvarchar](1000) NULL,
 CONSTRAINT [PK_inci_CliArt] PRIMARY KEY CLUSTERED 
(
	[empresa] ASC,
	[cliente] ASC,
	[fecha] ASC,
	[articulo] ASC,
	[hora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO