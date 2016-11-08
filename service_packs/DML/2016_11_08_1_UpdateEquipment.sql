USE [KRR-PA-ISA95_PRODUCTION]
GO

UPDATE [dbo].[Equipment]
   SET 
      [EquipmentLevel] = 'Area'
     ,[Equipment] = 116
 WHERE  [ID] = 298 or [ID] = 303 


DELETE FROM [dbo].[Equipment]
      WHERE id = 126 or id = 127

Update [dbo].[Equipment]
SET [Equipment] = 115
Where [ID]=149 

GO