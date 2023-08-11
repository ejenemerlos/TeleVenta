CREATE TABLE [dbo].[TeleVentaListados](
	[id] [varchar](50) NULL,
	nombreListado [nvarchar](100) NULL,
	[cliente] [varchar](50) NULL,
	[gestor] [varchar](8000) NULL,
	[horario] [varchar](20) NULL,
	fecha [varchar](10) NULL,
	hasta [varchar](10) NULL,
	[FechaInsertUpdate] [datetime] NOT NULL DEFAULT (getdate()),
	[IdDoc] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]