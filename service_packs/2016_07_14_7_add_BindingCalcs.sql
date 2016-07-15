SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

--------------------------------------------------------------
IF OBJECT_ID('dbo.get_CalculateBindingWeightByEquipment', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_CalculateBindingWeightByEquipment;
GO

CREATE FUNCTION dbo.get_CalculateBindingWeightByEquipment
(@EquipmentID    INT,
 @OriginalWeight INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @JobOrderID INT, @BINDING_DIA [NVARCHAR](50), @BINDING_QTY [NVARCHAR](50), @BINDING_WEIGHT_COEF FLOAT, @SCALES_TYPE [NVARCHAR](50), @PACK_RULE [NVARCHAR](50), @PACK_WEIGHT [NVARCHAR](50);
         SET @SCALES_TYPE = dbo.get_EquipmentPropertyValue(@EquipmentID, N'SCALES_TYPE');
         IF @SCALES_TYPE = N'BUNT'
             BEGIN
                 SET @PACK_RULE = dbo.get_EquipmentPropertyValue(@EquipmentID, N'PACK_RULE');
                 IF @PACK_RULE = N'CALC'
                     BEGIN
                         SET @JobOrderID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'JOB_ORDER_ID');
                         IF @JobOrderID IS NULL
                             RETURN @OriginalWeight;
                         SET @BINDING_QTY = dbo.get_JobOrderPropertyValue(@JobOrderID, N'BINDING_QTY');
                         SET @BINDING_DIA = dbo.get_JobOrderPropertyValue(@JobOrderID, N'BINDING_DIA');
                         SET @BINDING_WEIGHT_COEF =
                         (
                             SELECT mdpCoef.[Value]
                             FROM MaterialDefinitionProperty mdpQty
                                  INNER JOIN MaterialClassProperty mcpQty ON mcpQty.ID = mdpQty.ClassPropertyID
                                                                             AND mcpQty.[Value] = N'BINDING_QTY'
                                                                             AND mdpQty.[Value] = @BINDING_QTY
                                  INNER JOIN MaterialDefinitionProperty mdpDia ON mdpDia.MaterialDefinitionID = mdpQty.MaterialDefinitionID
                                  INNER JOIN MaterialClassProperty mcpDia ON mcpDia.ID = mdpDia.ClassPropertyID
                                                                             AND mcpDia.[Value] = N'BINDING_DIA'
                                                                             AND mdpDia.[Value] = @BINDING_DIA
                                  INNER JOIN MaterialDefinitionProperty mdpCoef ON mdpCoef.MaterialDefinitionID = mdpDia.MaterialDefinitionID
                                  INNER JOIN MaterialClassProperty mcpCoef ON mcpCoef.ID = mdpCoef.ClassPropertyID
                                                                              AND mcpCoef.[Value] = N'BINDING_WEIGHT_COEF'
                         );
                         IF @BINDING_WEIGHT_COEF IS NOT NULL
                             RETURN @OriginalWeight * CAST(@BINDING_WEIGHT_COEF AS FLOAT);
                         ELSE
                         RETURN @OriginalWeight;
                     END;
                 ELSE
                 IF @PACK_RULE = N'ENTERED'
                     BEGIN
                         SET @PACK_WEIGHT = dbo.get_EquipmentPropertyValue(@EquipmentID, N'PACK_WEIGHT');
                         IF @PACK_WEIGHT IS NOT NULL
                             RETURN @OriginalWeight - CAST(@PACK_WEIGHT AS FLOAT);
                         ELSE
                         RETURN @OriginalWeight;
                     END;
                 ELSE
                 RETURN @OriginalWeight;;
             END;
         ELSE
         RETURN @OriginalWeight;
         RETURN @OriginalWeight;
     END;
GO

--------------------------------------------------------------
-- Функция округляет вес для конкретных весов
IF OBJECT_ID('dbo.get_RoundedWeightByEquipment', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_RoundedWeightByEquipment;
GO

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