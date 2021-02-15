CREATE TABLE [Configuracion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NULL,
	[valor] [varchar](max) NOT NULL,
	[fechaInsertUpdate] [datetime] NOT NULL,
	CONSTRAINT [PK_Configuracion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Configuracion] ADD  CONSTRAINT [DF_Configuracion_valor]  DEFAULT ((0)) FOR [valor]
GO
ALTER TABLE [dbo].[Configuracion] ADD  CONSTRAINT [DF_Configuracion_fechaInsertUpdate]  DEFAULT (getdate()) FOR [fechaInsertUpdate]
GO