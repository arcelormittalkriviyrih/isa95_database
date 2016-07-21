SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

DECLARE @EquipmentClassID int;

SELECT @EquipmentClassID = ID
FROM dbo.EquipmentClass
WHERE Code = N'PRINTER';

IF NOT EXISTS
(
	SELECT NULL
	FROM dbo.EquipmentClassProperty
	WHERE [Value] = N'PAPER_WIDTH'
)
BEGIN
	INSERT INTO dbo.EquipmentClassProperty( Description, [Value], EquipmentClassID )
	VALUES( N'Ширина бумаги в px', N'PAPER_WIDTH', @EquipmentClassID );
END;

INSERT INTO dbo.EquipmentProperty( [Value], EquipmentID, ClassPropertyID )
	   SELECT N'1078', ID, dbo.get_EquipmentClassPropertyByValue( N'PAPER_WIDTH' )
	   FROM Equipment
	   WHERE EquipmentClassID = @EquipmentClassID AND 
			 ID NOT IN
	   (
		   SELECT EquipmentID
		   FROM EquipmentProperty
		   WHERE ClassPropertyID = dbo.get_EquipmentClassPropertyByValue( N'PAPER_WIDTH' )
	   );

IF NOT EXISTS
(
	SELECT NULL
	FROM dbo.EquipmentClassProperty
	WHERE [Value] = N'PAPER_HEIGHT'
)
BEGIN
	INSERT INTO dbo.EquipmentClassProperty( Description, [Value], EquipmentClassID )
	VALUES( N'Высота бумаги в px', N'PAPER_HEIGHT', @EquipmentClassID );
END;


INSERT INTO dbo.EquipmentProperty( [Value], EquipmentID, ClassPropertyID )
	   SELECT N'1678', ID, dbo.get_EquipmentClassPropertyByValue( N'PAPER_HEIGHT' )
	   FROM Equipment
	   WHERE EquipmentClassID = @EquipmentClassID AND 
			 ID NOT IN
	   (
		   SELECT EquipmentID
		   FROM EquipmentProperty
		   WHERE ClassPropertyID = dbo.get_EquipmentClassPropertyByValue( N'PAPER_HEIGHT' )
	   );
GO