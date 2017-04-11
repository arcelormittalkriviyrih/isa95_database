
IF COLUMNPROPERTY(OBJECT_ID('PackagingClass','U'),'ParentID','ColumnId') IS NOT NULL
BEGIN
   ALTER TABLE [dbo].[PackagingClass]
	ALTER COLUMN [ParentID] [int]  NULL
END

