CREATE TABLE [dbo].[inci_CliPed](
	[pedido] [varchar](50) NOT NULL,
	[cliente] [varchar](50) NOT NULL,
	[incidencia] [char](2) NOT NULL,
	[descripcion] [varchar](100) NULL,
	[observaciones] [varchar](500) NULL,
	CONSTRAINT [PK_inci_CliPed] PRIMARY KEY CLUSTERED 
(
	[pedido] ASC,
	[cliente] ASC,
	[incidencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]