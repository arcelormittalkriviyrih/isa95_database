SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- add new column
IF OBJECT_ID ('dbo.WeightingOperations',N'U') IS NOT NULL and COLUMNPROPERTY(OBJECT_ID('WeightingOperations','U'),'TaringPersonID','ColumnId') IS NULL
begin
	ALTER TABLE [dbo].[WeightingOperations] 
	ADD [TaringPersonID] int NULL

	ALTER TABLE [dbo].[WeightingOperations]  WITH CHECK 
	ADD CONSTRAINT [FK_WeightingOperations_TaringPerson] FOREIGN KEY([TaringPersonID]) REFERENCES [dbo].[Person] ([ID])
end

GO
