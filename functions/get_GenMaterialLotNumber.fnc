IF OBJECT_ID('dbo.gen_MaterialLotNumber', N'SO') IS NULL 
   CREATE SEQUENCE dbo.gen_MaterialLotNumber AS INT START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999 CYCLE NO CACHE;
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_GenMaterialLotNumber', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_GenMaterialLotNumber;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*
   Function: get_GenMaterialLotNumber

   Функция генерирует уникальный № бирки

   Parameters:

      EquipmentID - ID весов,
	  SerialID    - Счётчик.
     
   Returns:
	  
	  № бирки.

*/
CREATE FUNCTION dbo.get_GenMaterialLotNumber(@EquipmentID  [INT],
                                             @SerialID     [INT])
RETURNS [NVARCHAR](12)
AS
BEGIN

DECLARE @MaterialLotNumber [NVARCHAR](12),
        @ScaleNO           [NVARCHAR](2);

SELECT @ScaleNO=ep.[Value]
FROM [dbo].[EquipmentProperty] ep
WHERE ep.[EquipmentID]=@EquipmentID
  AND ep.[ClassPropertyID]=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO');

SET @MaterialLotNumber=RIGHT(CAST(YEAR(CURRENT_TIMESTAMP) AS NVARCHAR),2) + 
RIGHT(REPLICATE('0',2) + LEFT(CAST(MONTH(CURRENT_TIMESTAMP) AS NVARCHAR), 2), 2) + 
RIGHT(REPLICATE('0',2) + LEFT(CAST(DAY(CURRENT_TIMESTAMP) AS NVARCHAR), 2), 2) + 
RIGHT(REPLICATE('0',2) + LEFT(@ScaleNO, 2), 2) + 
RIGHT(REPLICATE('0',4) + LEFT(CAST(@SerialID AS NVARCHAR), 4), 4)

RETURN @MaterialLotNumber;

END;
GO
