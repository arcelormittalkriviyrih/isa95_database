
IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_PackagingUnitsDocsProperty')
BEGIN
CREATE SEQUENCE [dbo].[gen_PackagingUnitsDocsProperty] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 
END


IF OBJECT_ID ('dbo.PackagingUnitsDocsProperty',N'U') IS NOT NULL
  DROP TABLE [dbo].[PackagingUnitsDocsProperty];
GO

/*
   Table: PackagingUnitsDocsProperty
    Свойства вагонов, содержащихся в документах
*/
CREATE TABLE [dbo].[PackagingUnitsDocsProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[ValueUnitofMeasure] [nvarchar](50) NULL,
	[PropertyType] [nvarchar](50) NULL,
	[PackagingUnitsDocsID] [int] NOT NULL,
	[ValueTime] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_PackagingUnitsDocsProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PackagingUnitsDocsProperty] ADD  CONSTRAINT [DEF_ID_PackagingUnitsDocsProperty]  DEFAULT (NEXT VALUE FOR [dbo].[gen_PackagingUnitsDocsProperty]) FOR [ID]
GO

ALTER TABLE [dbo].[PackagingUnitsDocsProperty]  WITH CHECK ADD  CONSTRAINT [FK_PackagingUnitsDocsProperty_PackagingUnitsDocs] FOREIGN KEY([PackagingUnitsDocsID])
REFERENCES [dbo].[PackagingUnitsDocs] ([ID])
GO

ALTER TABLE [dbo].[PackagingUnitsDocsProperty] CHECK CONSTRAINT [FK_PackagingUnitsDocsProperty_PackagingUnitsDocs]
GO