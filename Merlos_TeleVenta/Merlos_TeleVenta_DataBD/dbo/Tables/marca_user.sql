CREATE TABLE [dbo].[marca_user](
	[usuario] [char](20) NOT NULL,
	[marca] [char](10) NOT NULL,
	[fecha] [varchar](10) NOT NULL,
	[nombreTV] [varchar](50) NOT NULL,
 CONSTRAINT [PK_marca_user_1] PRIMARY KEY CLUSTERED 
(
	[usuario] ASC,
	[marca] ASC,
	[fecha] ASC,
	[nombreTV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[marca_user] ADD  CONSTRAINT [DF_marca_user_fecha]  DEFAULT ('PENDIENTE') FOR [fecha]
GO


