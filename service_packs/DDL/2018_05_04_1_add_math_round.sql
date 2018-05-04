SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
   Function: dbo.get_RoundedWeight
   
   Функция округляет вес.

   Parameters:

	  WeightValue	 - Исходный вес,
	  RoundRule		 - Правило округления,
	  RoundPrecision - Точность.
     
	Returns:

      Округлённый вес.
	
*/
ALTER FUNCTION [dbo].[get_RoundedWeight]
(@WeightValue INT,
 @RoundRule   NVARCHAR(50),
 @RoundPrecision  INT
)
RETURNS INT
AS
     BEGIN
         IF @RoundRule IS NULL
             RETURN @WeightValue;
		 IF @RoundRule = 'MATH'
             RETURN ROUND(@WeightValue,0);
         IF @RoundPrecision IS NULL
             RETURN @WeightValue;
		 IF @RoundPrecision = 0
             RETURN @WeightValue;
         IF @RoundRule = 'UP'
             BEGIN
                 IF @WeightValue % @RoundPrecision = 0
                     RETURN @WeightValue;
                 ELSE
                 RETURN @WeightValue + @RoundPrecision - @WeightValue % @RoundPrecision;
             END;
         IF @RoundRule = 'DOWN'
             RETURN @WeightValue - @WeightValue % @RoundPrecision;		 
         RETURN @WeightValue;
     END;
GO