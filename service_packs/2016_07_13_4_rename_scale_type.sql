SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

BEGIN TRANSACTION;

UPDATE [dbo].[EquipmentProperty]
SET Value=CASE Value WHEN N'Карманные' THEN N'POCKET' 
                     WHEN N'Ручные' THEN N'MANUAL' 
                     WHEN N'Весы линии упаковки' THEN N'LINEPACK'
                     WHEN N'Бунтовые' THEN N'BUNT'  
          END
WHERE [ClassPropertyID] IN (SELECT [ID] FROM [dbo].[EquipmentClassProperty] WHERE [Value]=N'SCALES_TYPE')
  AND [Value] IN (N'Карманные',N'Ручные',N'Весы линии упаковки',N'Бунтовые');

COMMIT;
GO

