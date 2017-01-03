SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

insert into [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClassProperty]
  (       [Description]
      ,[Value]
      ,[EquipmentClassID])
         values(
         N'Идентификатор ЖД весов',
         N'WEIGHBRIDGES_ID',
         11
         )


GO