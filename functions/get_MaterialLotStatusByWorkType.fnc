﻿--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_MaterialLotStatusByWorkType', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_MaterialLotStatusByWorkType];
GO
/*
   Function: get_MaterialLotStatusByWorkType
   
   Функция возвращает MaterialLot.Status по режиму работы.

   Parameters:

	  WorkType - Режим работы.
     
	Returns:

      MaterialLot.Status.
	
*/
CREATE FUNCTION [dbo].[get_MaterialLotStatusByWorkType](@WorkType NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
   IF @WorkType = N'Sort'
      RETURN N'2';
   ELSE IF @WorkType = N'Reject'
      RETURN N'3';
   ELSE IF @WorkType = N'Separate'
      RETURN N'4';

   RETURN N'0';
END;
GO
