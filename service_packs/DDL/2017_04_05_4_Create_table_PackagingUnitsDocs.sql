IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_PackagingUnitsDocs')
BEGIN
CREATE SEQUENCE [dbo].[gen_PackagingUnitsDocs] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 
END
GO

IF OBJECT_ID ('dbo.PackagingUnitsDocs',N'U') IS NOT NULL
  if exists(SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PackagingUnitsDocs_Documentations]') AND parent_object_id = OBJECT_ID(N'[dbo].[PackagingUnitsDocs]'))
	ALTER TABLE [dbo].[PackagingUnitsDocs] DROP CONSTRAINT [FK_PackagingUnitsDocs_Documentations]
  
  if exists(SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PackagingUnitsDocs_PackagingUnits]') AND parent_object_id = OBJECT_ID(N'[dbo].[PackagingUnitsDocs]'))
	ALTER TABLE [dbo].[PackagingUnitsDocs] DROP CONSTRAINT [FK_PackagingUnitsDocs_PackagingUnits]
   
  DROP TABLE [dbo].[PackagingUnitsDocs];
GO

/*
   Table: PackagingUnitsDocs
    Вагоны, содержащиеся в документах
*/

CREATE TABLE [dbo].[PackagingUnitsDocs](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[DocumentationsID] [int] NULL,
	[PackagingUnitsID] [int] NULL,
	[Status] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_PackagingUnitsDocs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PackagingUnitsDocs] ADD  CONSTRAINT [DEF_ID_PackagingUnitsDocs]  DEFAULT (NEXT VALUE FOR [dbo].[gen_PackagingUnitsDocs]) FOR [ID]
GO

ALTER TABLE [dbo].[PackagingUnitsDocs]  WITH CHECK ADD  CONSTRAINT [FK_PackagingUnitsDocs_Documentations] FOREIGN KEY([DocumentationsID])
REFERENCES [dbo].[Documentations] ([ID])
GO

ALTER TABLE [dbo].[PackagingUnitsDocs] CHECK CONSTRAINT [FK_PackagingUnitsDocs_Documentations]
GO

ALTER TABLE [dbo].[PackagingUnitsDocs]  WITH CHECK ADD  CONSTRAINT [FK_PackagingUnitsDocs_PackagingUnits] FOREIGN KEY(PackagingUnitsID)
REFERENCES [dbo].[PackagingUnits] ([ID])
GO

ALTER TABLE [dbo].[PackagingUnitsDocs] CHECK CONSTRAINT [FK_PackagingUnitsDocs_PackagingUnits]
GO

