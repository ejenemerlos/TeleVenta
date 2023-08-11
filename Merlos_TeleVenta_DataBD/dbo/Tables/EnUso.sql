CREATE TABLE [dbo].[EnUso](
	[IdEnUso] [int] IDENTITY(1,1) NOT NULL,
	[Clave] [nvarchar](100) NULL,
	[TIpo] [nvarchar](100) NULL,
	[Objeto] [nvarchar](100) NULL,
	[Estado] [smallint] NULL DEFAULT ((0)),
	[Usuario] [nvarchar](100) NULL DEFAULT (user_name()),
	[FechaInsertUpdate] [datetime] NULL DEFAULT (getdate())
) ON [PRIMARY]