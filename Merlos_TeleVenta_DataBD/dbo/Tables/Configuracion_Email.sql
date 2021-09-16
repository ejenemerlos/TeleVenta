CREATE TABLE [dbo].[Configuracion_Email](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Cuenta] [varchar](255) NULL,
	[ServidorSMTP] [varchar](255) NULL,
	[Puerto] [varchar](10) NULL,
	[SSL] [bit] NULL,
	[Usuario] [varchar](255) NULL,
	[Password] [varchar](255) NULL,
	[FechaInsertUpdate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Configuracion_Email] ADD  CONSTRAINT [DF_Configuracion_Email_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO

