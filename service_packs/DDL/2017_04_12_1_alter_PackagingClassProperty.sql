/*set [PackagingClassProperty] column to NULLABLE*/
IF COLUMNPROPERTY(OBJECT_ID('PackagingClassProperty','U'),'PackagingClassProperty','ColumnId') IS NOT NULL
BEGIN
   ALTER TABLE [dbo].[PackagingClassProperty]
	ALTER COLUMN [PackagingClassProperty] [int]  NULL
END

GO
