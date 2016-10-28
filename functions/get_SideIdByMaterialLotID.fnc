--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_SideIdByMaterialLotID', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIdByDescription;
GO
/*
   Function: get_SideIdByMaterialLotID

   Функция получения ID стороны стана по MaterialLotID

   Parameters:

      MaterialLotID - MaterialLotID.
      
   Returns:
	  
	  ID стороны стана.

*/
CREATE FUNCTION dbo.get_SideIdByMaterialLotID(@MaterialLotID INT)
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=e.Equipment
FROM EquipmentProperty p,EquipmentClassProperty cp, Equipment e 
where p.ClassPropertyID=cp.ID 
and p.Value=(select SUBSTRING(FactoryNumber,7,2) from MaterialLot where id=@MaterialLotID) 
and cp.Value=N'SCALES_NO'
and p.EquipmentID=e.ID

RETURN @Id;

END;
GO
