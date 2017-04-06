
IF COLUMNPROPERTY(OBJECT_ID('DocumentationsProperty','U'),'DocumentationsProperty','ColumnId') IS NOT NULL
BEGIN
	ALTER TABLE [dbo].[DocumentationsProperty]
	ALTER COLUMN [DocumentationsProperty] int NULL
END

