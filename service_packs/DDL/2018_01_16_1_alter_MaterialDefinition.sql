
IF COLUMNPROPERTY(OBJECT_ID('MaterialDefinition','U'),'Description','ColumnId') IS NOT NULL
BEGIN
   ALTER TABLE [dbo].[MaterialDefinition]
	ALTER COLUMN [Description] [nvarchar](100) NULL
END

GO

