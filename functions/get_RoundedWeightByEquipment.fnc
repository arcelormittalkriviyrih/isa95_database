--------------------------------------------------------------

IF OBJECT_ID('dbo.get_RoundedWeightByEquipment', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_RoundedWeightByEquipment;
GO
/*
   Function: get_RoundedWeightByEquipment
   
   Функция округляет вес для конкретных весов.

   Parameters:

      EquipmentID - ID весов,
	  WeightValue - Исходный вес
     
	Returns:

      Округлённый вес.
	
	See Also:

      <get_RoundedWeight>

*/

CREATE FUNCTION dbo.get_RoundedWeightByEquipment
(@WeightValue INT,
 @EquipmentID INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @RoundPrecision INT, @RoundRule [NVARCHAR](50);
         SET @RoundRule = dbo.get_EquipmentPropertyValue(@EquipmentID, N'ROUND_RULE');
         SET @RoundPrecision = dbo.get_EquipmentPropertyValue(@EquipmentID, N'ROUND_PRECISION');
	    SET @WeightValue = dbo.get_CalculateBindingWeightByEquipment(@EquipmentID,@WeightValue);
         RETURN dbo.[get_RoundedWeight](@WeightValue, @RoundRule, @RoundPrecision);
     END;
GO