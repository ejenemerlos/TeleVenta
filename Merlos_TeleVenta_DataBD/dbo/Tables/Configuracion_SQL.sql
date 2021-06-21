CREATE TABLE [dbo].[Configuracion_SQL](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[EJERCICIO] [varchar](50) NULL,
	[GESTION] [varchar](50) NULL,
	[LETRA] [char](2) NULL,
	[COMUN] [varchar](50) NULL,
	[CAMPOS] [varchar](50) NULL,
	[EMPRESA] [varchar](50) NULL,
	[NOMBRE_EMPRESA] [varchar](100) NULL,
	[ANYS] [int] NOT NULL,
	[MesesConsumo] [int] NOT NULL,
	[TVSerie] [varchar](50) NULL,
	[TarifaMinima] [varchar](50) NULL,
	[FechaInsertUpdate] [datetime] NOT NULL,
 CONSTRAINT [PK_Gestion_SQL] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Configuracion_SQL] ADD  CONSTRAINT [DF__Configurac__ANYS__2D27B809]  DEFAULT ((0)) FOR [ANYS]
GO
ALTER TABLE [dbo].[Configuracion_SQL] ADD  CONSTRAINT [DF_Configuracion_SQL_MesesConsumo]  DEFAULT ((1)) FOR [MesesConsumo]
GO
ALTER TABLE [dbo].[Configuracion_SQL] ADD  CONSTRAINT [DF_Gestion_SQL_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO

