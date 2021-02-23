
CREATE TABLE [dbo].[inci_CliPed](
	[empresa] [char](2) NULL,
	[fecha] [varchar](10) NULL,
	[hora] [varchar](5) NULL,
	[nombreTV] [varchar](100) NULL,
	[idpedido] [varchar](50) NULL,
	[cliente] [varchar](50) NOT NULL,
	[incidencia] [char](2) NOT NULL,
	[descripcion] [varchar](100) NULL,
	[observaciones] [varchar](500) NULL
) ON [PRIMARY]
GO

