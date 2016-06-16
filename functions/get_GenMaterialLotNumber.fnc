IF OBJECT_ID('dbo.gen_MaterialLotNumber', N'SO') IS NULL 
   CREATE SEQUENCE dbo.gen_MaterialLotNumber AS INT START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999 CYCLE NO CACHE;
GO

--------------------------------------------------------------
-- Функция генерирует уникальный № бирки
IF OBJECT_ID ('dbo.get_GenMaterialLotNumber', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_GenMaterialLotNumber;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.get_GenMaterialLotNumber(@ScaleNo  [NVARCHAR](2),
                                             @SerialID [INT])
RETURNS [NVARCHAR](12)
AS
BEGIN

DECLARE @MaterialLotNumber [NVARCHAR](12);

SET @MaterialLotNumber=RIGHT(CAST(YEAR(CURRENT_TIMESTAMP) AS NVARCHAR),2) + 
RIGHT(REPLICATE('0',2) + LEFT(CAST(MONTH(CURRENT_TIMESTAMP) AS NVARCHAR), 2), 2) + 
RIGHT(REPLICATE('0',2) + LEFT(CAST(DAY(CURRENT_TIMESTAMP) AS NVARCHAR), 2), 2) + 
RIGHT(REPLICATE('0',4) + LEFT(CAST(@SerialID AS NVARCHAR), 4), 4)

RETURN @MaterialLotNumber;

END;
GO
