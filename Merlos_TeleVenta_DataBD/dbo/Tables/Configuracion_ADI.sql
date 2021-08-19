CREATE TABLE [dbo].[Configuracion_ADI](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EJER] [nchar](10) NULL,
	[EMPRESA] [nchar](10) NULL,
	[NUMERO] [nchar](10) NULL,
	[LETRA] [nchar](10) NULL,
	[CAMPO] [nchar](10) NULL,
	[VALOR] [nchar](10) NULL,
	[FechaInsertUpdate] [datetime] NULL,
 CONSTRAINT [PK_Configuracion_ADI] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Configuracion_ADI] ADD  CONSTRAINT [DF_Configuracion_ADI_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO