SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

DECLARE @EquipmentClassID int;

SELECT @EquipmentClassID = ID
FROM dbo.EquipmentClass
WHERE Code = N'SIDE';

IF NOT EXISTS
(
	SELECT NULL
	FROM dbo.EquipmentClassProperty
	WHERE [Value] = N'SIDE_ENABLED'
)
BEGIN
	INSERT INTO dbo.EquipmentClassProperty( Description, [Value], EquipmentClassID )
	VALUES( N'Сторона стана включена', N'SIDE_ENABLED', @EquipmentClassID );
END;

IF NOT EXISTS (SELECT NULL from EquipmentProperty where ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ENABLED') and EquipmentID in (SELECT EquipmentID
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' )))
    INSERT INTO dbo.EquipmentProperty( [Value], EquipmentID, ClassPropertyID )
	   SELECT N'1', EquipmentID, dbo.get_EquipmentClassPropertyByValue( N'SIDE_ENABLED' )
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' );

GO