﻿CREATE TABLE [dbo].[inci_cli](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [varchar](50) NOT NULL,
	[nombre] [varchar](100) NULL,
	[usuario] [varchar](100) NULL DEFAULT (user_name()) ,	
	[FechaInsertUpdate] datetime null default(getdate())
	CONSTRAINT [PK_inci_cli] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]