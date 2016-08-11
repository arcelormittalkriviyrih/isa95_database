SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

DECLARE @EquipmentClassID int;

SELECT @EquipmentClassID = ID
FROM dbo.EquipmentClass
WHERE Code = N'SIDE';

IF NOT EXISTS
(
	SELECT NULL
	FROM dbo.EquipmentClassProperty
	WHERE [Value] = N'CONTROLLER_ID'
)
BEGIN
	INSERT INTO dbo.EquipmentClassProperty( Description, [Value], EquipmentClassID )
	VALUES( N'Номер весового контроллера', N'CONTROLLER_ID', @EquipmentClassID );
END;

IF NOT EXISTS (SELECT NULL from EquipmentProperty where ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID') and EquipmentID in (SELECT EquipmentID
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' ) and [Value]=N'MS_250_1_LEFT'))
    INSERT INTO dbo.EquipmentProperty( [Value], EquipmentID, ClassPropertyID )
	   SELECT N'1', EquipmentID, dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID' )
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' ) and [Value]=N'MS_250_1_LEFT';

IF NOT EXISTS (SELECT NULL from EquipmentProperty where ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID') and EquipmentID in (SELECT EquipmentID
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' ) and [Value]=N'MS_250_1_RIGHT'))
    INSERT INTO dbo.EquipmentProperty( [Value], EquipmentID, ClassPropertyID )
	   SELECT N'2', EquipmentID, dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID' )
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' ) and [Value]=N'MS_250_1_RIGHT';

SELECT @EquipmentClassID = ID
FROM dbo.EquipmentClass
WHERE Code = N'PRINTER';

IF NOT EXISTS
(
	SELECT NULL
	FROM dbo.EquipmentClassProperty
	WHERE [Value] = N'PRINTER_STATUS'
)
BEGIN
	INSERT INTO dbo.EquipmentClassProperty( Description, [Value], EquipmentClassID )
	VALUES( N'Состояние принтера', N'PRINTER_STATUS', @EquipmentClassID );
END;
GO