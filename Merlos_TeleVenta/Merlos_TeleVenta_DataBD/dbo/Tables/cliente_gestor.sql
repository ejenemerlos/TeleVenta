CREATE TABLE [dbo].[cliente_gestor](
	[cliente] [varchar](50) NOT NULL,
	[gestor] [varchar](10) NOT NULL,
	[nombreGestor] [varchar](100) NULL,
	[usuarioGestor] [varchar](50) NULL,
 CONSTRAINT [PK_cliente_gestor] PRIMARY KEY CLUSTERED 
(
	[cliente] ASC,
	[gestor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO