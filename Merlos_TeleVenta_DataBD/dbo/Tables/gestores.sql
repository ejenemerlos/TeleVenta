CREATE TABLE [dbo].[gestores](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [varchar](50) NULL,
	[nombre] [varchar](50) NULL,
	[apellidos] [varchar](100) NULL,
	[fechaInsertUpdate] [datetime] NULL,
 CONSTRAINT [PK_gestores] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[gestores] ADD  CONSTRAINT [DF_gestores_fechaInsertUpdate]  DEFAULT (getdate()) FOR [fechaInsertUpdate]
GO


