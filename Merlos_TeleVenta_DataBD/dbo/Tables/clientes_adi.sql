CREATE TABLE [dbo].[clientes_adi](
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
	[gestor] [nvarchar](10) NULL,
	[telefono] [varchar](20) NULL,
	[contacto] [varchar](10) NULL,
	[persona contacto] [nvarchar](255) NULL,
 CONSTRAINT [PK_clientes_adi] PRIMARY KEY CLUSTERED 
(
	[cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO