﻿CREATE TABLE [dbo].[inci_art](
	[codigo] [char](2) NOT NULL,
	[nombre] [char](50) NULL,
	CONSTRAINT [PK_inci_art] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]