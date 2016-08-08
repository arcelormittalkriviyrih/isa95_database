--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentIdByDescription', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIdByDescription;
GO
/*
   Function: get_EquipmentIdByDescription

   Функция вычитки поля ID из таблицы Equipment по значению поля Description

   Parameters:

      Description - Значение поля Description.
      
   Returns:
	  
	  ID весов.

*/
CREATE FUNCTION dbo.get_EquipmentIdByDescription(@Description [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=[ID] 
FROM [dbo].[Equipment]
WHERE UPPER(LTRIM(RTRIM([Description])))=UPPER(LTRIM(RTRIM(@Description)));

RETURN @Id;

END;
GO
