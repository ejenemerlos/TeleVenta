CREATE TABLE [dbo].[llamadasOD](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTeleVentaOrigen] [varchar](50) NULL,
	[cliente] [nchar](10) NULL,
	[gestor] [varchar](50) NULL,
	[fechaHora] [datetime] NULL,
	[insertada] [bit] NOT NULL,
	[realizada] [bit] NOT NULL,
	[FechaInsertUpdate] [datetime] NOT NULL,
 CONSTRAINT [PK_llamadasOD] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[llamadasOD] ADD  CONSTRAINT [DF_llamadasOD_insertada]  DEFAULT ((0)) FOR [insertada]
GO

ALTER TABLE [dbo].[llamadasOD] ADD  CONSTRAINT [DF_llamadasOD_realizada]  DEFAULT ((0)) FOR [realizada]
GO

ALTER TABLE [dbo].[llamadasOD] ADD  CONSTRAINT [DF_llamadasOD_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO

