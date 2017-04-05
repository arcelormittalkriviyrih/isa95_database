
IF COLUMNPROPERTY(OBJECT_ID('DocumentationsClass','U'),'ParentID','ColumnId') IS NOT NULL
BEGIN
	ALTER TABLE [dbo].[DocumentationsClass]
	ALTER COLUMN [ParentID] int NULL
END