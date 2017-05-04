
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PackagingUnits_PackagingClass]') AND parent_object_id = OBJECT_ID(N'[dbo].[PackagingUnits]'))
ALTER TABLE [dbo].[PackagingUnits] 
DROP CONSTRAINT [FK_PackagingUnits_PackagingClass] 

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PackagingUnits_Location]') AND parent_object_id = OBJECT_ID(N'[dbo].[PackagingUnits]'))
ALTER TABLE [dbo].[PackagingUnits] 
DROP CONSTRAINT [FK_PackagingUnits_Location] 

IF COLUMNPROPERTY(OBJECT_ID('PackagingUnits','U'),'Location','ColumnId') IS NOT NULL
BEGIN
   ALTER TABLE [dbo].[PackagingUnits]
	ALTER COLUMN [Location] [int] NULL
END

GO

