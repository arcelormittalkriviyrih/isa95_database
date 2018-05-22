
IF COLUMNPROPERTY(OBJECT_ID('PackagingUnits','U'),'PackagingClassID','ColumnId') IS NULL
BEGIN
   ALTER TABLE [dbo].[PackagingUnits]
	ADD [PackagingClassID] [int] NULL
END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PackagingClassID_PackagingClass]') AND parent_object_id = OBJECT_ID(N'[dbo].[PackagingUnits]'))
ALTER TABLE [dbo].[PackagingUnits]  WITH CHECK ADD CONSTRAINT [FK_PackagingClassID_PackagingClass] FOREIGN KEY([PackagingClassID])
REFERENCES [dbo].[PackagingClass] ([ID])

GO

