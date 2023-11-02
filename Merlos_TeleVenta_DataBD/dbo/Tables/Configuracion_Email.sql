CREATE TABLE [dbo].[Configuracion_Email](
	[Id] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](255) NULL,
	[Descripcion] [nvarchar](1000) NULL,
	[NombreParaMostrar] [varchar](255) NULL,
	[Cuenta] [varchar](255) NULL,
	[ServidorSMTP] [varchar](255) NULL,
	[Puerto] [varchar](10) NULL,
	[SSL] [bit] NULL,
	[EnvioPorSQLServer] [bit] NULL,
	[EnvioPorDLL] [bit] NULL,
	[Usuario] [varchar](255) NULL,
	[Password] [varchar](255) NULL,
	[FechaInsertUpdate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Configuracion_Email] ADD  CONSTRAINT [DF_Configuracion_Email_EnvioPorSQLServer]  DEFAULT ((0)) FOR [EnvioPorSQLServer]
GO

ALTER TABLE [dbo].[Configuracion_Email] ADD  CONSTRAINT [DF_Configuracion_Email_EnvioPorDLL]  DEFAULT ((0)) FOR [EnvioPorDLL]
GO

ALTER TABLE [dbo].[Configuracion_Email] ADD  CONSTRAINT [DF_Configuracion_Email_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO
