--------------------------------------------------------------
-- Процедура вычитки поля ID из таблицы EquipmentProperty по значению поля Value
IF OBJECT_ID ('dbo.get_EquipmentIdByPropertyValue', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_EquipmentIdByPropertyValue];
GO

CREATE FUNCTION [dbo].[get_EquipmentIdByPropertyValue](@Value [nvarchar](50),
                                                       @EquipmentClassPropertyValue [NVARCHAR](50))
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=[EquipmentID]
FROM [dbo].[EquipmentProperty] ep
WHERE ep.[Value]=@Value
  AND ep.[ClassPropertyID]=[dbo].[get_EquipmentClassPropertyByValue](@EquipmentClassPropertyValue);

RETURN @Id;

END;
GO
