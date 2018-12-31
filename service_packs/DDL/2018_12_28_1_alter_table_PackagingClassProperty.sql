
IF COLUMNPROPERTY(OBJECT_ID('PackagingClassProperty','U'),'Value','ColumnId') IS NOT NULL
BEGIN
	ALTER TABLE [dbo].[PackagingClassProperty]
	ALTER COLUMN [Value] [nvarchar](500) NULL
END

