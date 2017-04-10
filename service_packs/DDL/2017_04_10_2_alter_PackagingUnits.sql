IF COLUMNPROPERTY(OBJECT_ID('PackagingUnits','U'),'PackagingClassID','ColumnId') IS NULL
BEGIN
	ALTER TABLE [dbo].PackagingUnits
	ADD [PackagingClassID] [int] NULL;

    ALTER TABLE [dbo].PackagingUnits  WITH CHECK ADD  CONSTRAINT [FK_PackagingUnits_PackagingClass] FOREIGN KEY([PackagingClassID])
    REFERENCES [dbo].[PackagingClass] ([ID]);

    ALTER TABLE [dbo].PackagingUnits CHECK CONSTRAINT [FK_PackagingUnits_PackagingClass];
END