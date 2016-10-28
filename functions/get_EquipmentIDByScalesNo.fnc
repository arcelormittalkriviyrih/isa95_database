--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentIDByScalesNo', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIDByScalesNo;
GO
/*
   Function: get_EquipmentIDByScalesNo

   Функция вычитки поля ID из таблицы Equipment по EquipmentClassProperty N'SCALES_NO'

   Parameters:

      Value - Идентификатор весов.
     
   Returns:
	  
	  ID весов.

*/
CREATE FUNCTION dbo.get_EquipmentIDByScalesNo(@Value [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @EquipmentID INT;

SELECT @EquipmentID=eqp.EquipmentID
FROM dbo.EquipmentProperty eqp
     INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'SCALES_NO')
WHERE eqp.value=@Value;

RETURN @EquipmentID;

END;
GO
