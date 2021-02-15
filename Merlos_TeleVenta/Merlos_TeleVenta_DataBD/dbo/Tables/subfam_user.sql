
CREATE TABLE [dbo].[subfam_user](
	[usuario] [char](20) NOT NULL,
	[subfamilia] [char](4) NOT NULL,
	[fecha] [varchar](10) NOT NULL,
	[nombreTV] [varchar](50) NOT NULL,
 CONSTRAINT [PK_subfam_user] PRIMARY KEY CLUSTERED 
(
	[usuario] ASC,
	[subfamilia] ASC,
	[fecha] ASC,
	[nombreTV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[subfam_user] ADD  CONSTRAINT [DF_subfam_user_fecha]  DEFAULT ('PENDIENTE') FOR [fecha]
GO

