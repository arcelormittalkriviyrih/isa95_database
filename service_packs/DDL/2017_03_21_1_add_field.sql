IF COLUMNPROPERTY(OBJECT_ID('PackagingUnitsProperty','U'),'ValueTime','ColumnId') IS NULL
ALTER TABLE [dbo].[PackagingUnitsProperty]
add  	[ValueTime] datetime NULL


IF COLUMNPROPERTY(OBJECT_ID('JobResponse','U'),'PackagingUnitsID','ColumnId') IS NULL
BEGIN
  ALTER TABLE [dbo].[JobResponse]
  ADD [PackagingUnitsID] [int] NULL

  ALTER TABLE [dbo].[JobResponse]  WITH CHECK ADD  CONSTRAINT [FK_JobResponse_PackagingUnits] FOREIGN KEY([PackagingUnitsID])
  REFERENCES [dbo].[PackagingUnits] ([ID])

  ALTER TABLE [dbo].[JobResponse] CHECK CONSTRAINT [FK_JobResponse_PackagingUnits]
END

