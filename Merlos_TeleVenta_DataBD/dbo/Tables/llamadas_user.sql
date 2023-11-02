CREATE TABLE [dbo].[llamadas_user](
	[nombreTV] [nvarchar](250) NOT NULL,
	[usuario] [varchar](20) NOT NULL,
	[fecha] [varchar](10) NOT NULL,
	[cliente] [char](20) NOT NULL,
	[lunes] [bit] NULL,
	[hora_lunes] [char](15) NULL,
	[martes] [bit] NULL,
	[hora_martes] [char](15) NULL,
	[miercoles] [bit] NULL,
	[hora_miercoles] [char](15) NULL,
	[jueves] [bit] NULL,
	[hora_jueves] [char](15) NULL,
	[viernes] [bit] NULL,
	[hora_viernes] [char](15) NULL,
	[sabado] [bit] NULL,
	[hora_sabado] [char](15) NULL,
	[domingo] [bit] NULL,
	[hora_domingo] [char](15) NULL,
	[tipo_llama] [int] NULL,
	[dias_period] [int] NULL,
	[completado] [int] NULL,
	[nCompletado] [varchar](50) NULL,
	[idpedido] [varchar](50) NULL,
	[pedido] [varchar](50) NOT NULL,
	[NOMBRE] [varchar](50) NULL,
	[VENDEDOR] [varchar](50) NULL,
	[horario] [varchar](20) NULL,
 CONSTRAINT [PK_llamadas_user] PRIMARY KEY CLUSTERED 
(
	[nombreTV] ASC,
	[usuario] ASC,
	[fecha] ASC,
	[cliente] ASC,
	[pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[llamadas_user] ADD  CONSTRAINT [DF__llamadas___pedid__367C1819]  DEFAULT ('') FOR [pedido]
GO
