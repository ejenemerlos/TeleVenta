﻿CREATE TABLE [dbo].[config_telev](
	[empresa] [char](2) NOT NULL,
	[consumo] [int] NULL,
	CONSTRAINT [PK_config_telev] PRIMARY KEY CLUSTERED 
(
	[empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]