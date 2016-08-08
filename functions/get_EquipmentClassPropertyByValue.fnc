--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentClassPropertyByValue', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentClassPropertyByValue;
GO
/*
   Function: get_EquipmentClassPropertyByValue

   Функция вычитки поля ID из таблицы EquipmentClassProperty по значению поля Value

   Parameters:

      Value - Значение поля Value.
      
   Returns:
	  
	  EquipmentClassProperty ID.

*/
CREATE FUNCTION dbo.get_EquipmentClassPropertyByValue(@Value [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=[ID] 
FROM [dbo].[EquipmentClassProperty]
WHERE [Value]=@Value;

RETURN @Id;

END;
GO
