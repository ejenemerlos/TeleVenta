
CREATE TABLE [dbo].[ObservacionesInternas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[cliente] [varchar](50) NULL,
	[observaciones] [varchar](8000) NULL,
	[FechaInsertUpdate] [datetime] NULL,
 CONSTRAINT [PK_ObservacionesInternas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ObservacionesInternas] ADD  CONSTRAINT [DF_ObservacionesInternas_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO

