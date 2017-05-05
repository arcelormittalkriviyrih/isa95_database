
IF COLUMNPROPERTY(OBJECT_ID('DocumentationsProperty','U'),'DocumentationsClassPropertyID','ColumnId') IS NULL
BEGIN
   ALTER TABLE [dbo].[DocumentationsProperty]
	ADD [DocumentationsClassPropertyID] [int] NULL
END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DocumentationsClassPropertyID_DocumentationsClassProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[DocumentationsProperty]'))
ALTER TABLE [dbo].[DocumentationsProperty]  WITH CHECK 
ADD CONSTRAINT [FK_DocumentationsClassPropertyID_DocumentationsClassProperty] FOREIGN KEY([DocumentationsClassPropertyID])
REFERENCES [dbo].[DocumentationsClassProperty] ([ID])

GO

