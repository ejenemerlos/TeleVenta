CREATE TABLE [dbo].[Merlos_Log](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[accion] [nvarchar](max) NULL,
	[error] [nvarchar](max) NULL,
	[FechaInsertUpdate] [datetime] NULL DEFAULT (getdate()),
	[Usuario] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO