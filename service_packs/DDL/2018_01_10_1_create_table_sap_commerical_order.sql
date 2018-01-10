SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.sap_commerical_order',N'U') IS NOT NULL
  DROP TABLE dbo.sap_commerical_order;
GO
--------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[sap_commerical_order](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[timestamp] [datetime] NULL CONSTRAINT [DF_KEP_Analytics_Weight_archive_DT]  DEFAULT (getdate()),
	[SelesOrder] [nvarchar](250) NULL,
	[Contract] [nvarchar](250) NULL,
	[CountryName] [nvarchar](250) NULL,
	[ProductName] [nvarchar](250) NULL,
	[Size] [nvarchar](250) NULL,
	[Lenght] [nvarchar](250) NULL,
	[SteelGrade] [nvarchar](250) NULL,
	[ProductClass] [nvarchar](250) NULL,
	[DSTU] [nvarchar](250) NULL,
	[Order] [nvarchar](250) NULL,
	[TransferSuccess] [nvarchar](50) NULL,
	[error] [nvarchar](250) NULL,
 CONSTRAINT [PK_sap_commerical_order] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


