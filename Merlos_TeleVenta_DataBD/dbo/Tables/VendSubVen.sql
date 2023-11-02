CREATE TABLE [dbo].[VendSubVend](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Vendedor] [varchar](50) NULL,
	[SubVendedor] [varchar](50) NULL,
	[FechaInsertUpdate] [datetime] NULL,
 CONSTRAINT [PK_VendSubVend] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[VendSubVend] ADD  CONSTRAINT [DF_VendSubVend_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO
