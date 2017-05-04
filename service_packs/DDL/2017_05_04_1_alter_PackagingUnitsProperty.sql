
IF COLUMNPROPERTY(OBJECT_ID('PackagingUnitsProperty','U'),'PackagingUnitsProperty','ColumnId') IS NOT NULL
BEGIN
   ALTER TABLE [dbo].[PackagingUnitsProperty]
	ALTER COLUMN [PackagingUnitsProperty] [int]  NULL
END

