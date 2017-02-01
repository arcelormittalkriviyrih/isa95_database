USE [KRR-PA-ISA95_PRODUCTION]
GO
SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON
GO


  Update [dbo].[Equipment] 
  SET [Equipment]=350,  [EquipmentLevel]='Area'
  Where ID=341

  Update [dbo].[Equipment] 
  SET [EquipmentLevel]='Site'
  Where [Equipment]=100



GO
