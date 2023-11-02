CREATE TABLE [dbo].[Eurowin_Log](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BD] [nvarchar](100) NULL,
	[Accion] [nvarchar](max) NULL,
	[Usuario] [nvarchar](100) NULL,
	[UsuarioSQL] [nvarchar](100) NULL,
	[FechaInsert] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Eurowin_Log] ADD  CONSTRAINT [DF_Eurowin_Log_UsuarioSQL]  DEFAULT (suser_sname()) FOR [UsuarioSQL]
GO

ALTER TABLE [dbo].[Eurowin_Log] ADD  CONSTRAINT [DF_Eurowin_Log_FechaInsert]  DEFAULT (getdate()) FOR [FechaInsert]
GO
