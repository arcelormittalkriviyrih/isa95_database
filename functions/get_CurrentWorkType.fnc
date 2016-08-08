--------------------------------------------------------------
-- Функция возвращает текущий режим по весам
IF OBJECT_ID ('dbo.get_CurrentWorkType', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_CurrentWorkType;
GO
/*
   Function: get_CurrentWorkType

   Функция возвращает текущий режим по весам

   Parameters:

      EquipmentID - ID весов.
      
   Returns:
	  
	  Текущий режим работы АРМ.

*/
CREATE FUNCTION dbo.get_CurrentWorkType(@EquipmentID INT)
RETURNS [NVARCHAR](50)
AS
BEGIN

DECLARE @JobOrderID INT,
        @WorkType   [NVARCHAR](50);

SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
SELECT @WorkType=wr.[WorkType]
FROM [dbo].[JobOrder] jo INNER JOIN [dbo].[WorkRequest] wr ON (wr.[ID]=jo.[WorkRequest])
WHERE jo.[ID]=@JobOrderID;

RETURN @WorkType;

END;
GO
