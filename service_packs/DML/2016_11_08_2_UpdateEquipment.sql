USE [KRR-PA-ISA95_PRODUCTION]
GO

SET QUOTED_IDENTIFIER ON
GO

UPDATE [dbo].[Equipment]
	SET 
      [EquipmentLevel] = N'Area'
     ,[Equipment] = 116
WHERE [ID] in (298, 303) 


DELETE FROM [dbo].[Equipment]
      WHERE id in (126, 127)


UPDATE [dbo].[Equipment]
	SET [Equipment] = 115
WHERE [ID]=149 

GO
