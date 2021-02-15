CREATE TABLE [dbo].[llamadas](
	[usuario] [char](20) NOT NULL,
	[fecha] [date] NOT NULL,
	[cliente] [char](20) NOT NULL,
	[hora] [char](15) NOT NULL,
	[nombreTV] [nvarchar](100) NULL,
	[llamada] [bit] NULL,
	[incidencia] [char](2) NULL,
	[observa] [nvarchar](1000) NULL,
	[idpedido] [varchar](50) NULL,
	[pedido] [char](20) NULL,
	[completado] [int] NULL,
 CONSTRAINT [PK_llamadas] PRIMARY KEY CLUSTERED 
(
	[usuario] ASC,
	[fecha] ASC,
	[cliente] ASC,
	[hora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

