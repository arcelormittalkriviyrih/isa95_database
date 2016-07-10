--------------------------------------------------------------
-- Функция округляет вес
IF OBJECT_ID('dbo.get_RoundedWeight', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_RoundedWeight;
GO

CREATE FUNCTION dbo.get_RoundedWeight
(@WeightValue INT,
 @RoundRule   NVARCHAR(50),
 @RoundPrecision  INT
)
RETURNS INT
AS
     BEGIN
         IF @RoundRule IS NULL
             RETURN @WeightValue;
         IF @RoundPrecision IS NULL
             RETURN @WeightValue;
         IF @RoundRule = 'UP'
             RETURN @WeightValue + @RoundPrecision - @WeightValue % @RoundPrecision;
         IF @RoundRule = 'DOWN'
             RETURN @WeightValue - @WeightValue % @RoundPrecision;
         RETURN @WeightValue;
     END;
GO