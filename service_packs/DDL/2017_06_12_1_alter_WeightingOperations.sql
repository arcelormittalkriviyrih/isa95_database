
/*add column [TaringTime]*/
IF COLUMNPROPERTY(OBJECT_ID('WeightingOperations','U'),'TaringTime','ColumnId') IS NULL
BEGIN
   ALTER TABLE [dbo].[WeightingOperations]
	ADD [TaringTime] [datetimeoffset](7) NULL
END

GO
