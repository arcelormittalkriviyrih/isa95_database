SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- disable trigger to prevent insert fails
IF OBJECT_ID ('dbo.Ins_KEP_Analytics_Weight',N'TR') IS NOT NULL
	ALTER TABLE [dbo].[KEP_Analytics_Weight] 
	DISABLE TRIGGER [Ins_KEP_Analytics_Weight]

EXEC sp_rename '[dbo].[KEP_Analytics_Weight].[stabilizing_weight]', 'WeightStabilized_1', 'COLUMN'

ALTER TABLE [dbo].[KEP_Analytics_Weight] 
ADD [WeightStabilized_2] bit NULL

ALTER TABLE [dbo].[KEP_Analytics_Weight] 
DROP COLUMN [Tara_OK]

EXEC sp_rename '[dbo].[KEP_Analytics_Weight_archive].[stabilizing_weight]', 'WeightStabilized_1', 'COLUMN'

ALTER TABLE [dbo].[KEP_Analytics_Weight_archive] 
ADD [WeightStabilized_2] bit NULL

ALTER TABLE [dbo].[KEP_Analytics_Weight_archive] 
DROP COLUMN [Tara_OK]

GO
