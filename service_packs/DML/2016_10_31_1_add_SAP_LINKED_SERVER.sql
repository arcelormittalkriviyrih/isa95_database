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
	WHERE [Value] = N'SAP_LINKED_SERVER'
)
BEGIN
	INSERT INTO dbo.EquipmentClassProperty( Description, [Value], EquipmentClassID )
	VALUES( N'SAP', N'SAP_LINKED_SERVER', @EquipmentClassID );
END;

IF NOT EXISTS (SELECT NULL from EquipmentProperty where ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SAP_LINKED_SERVER') and EquipmentID in (SELECT EquipmentID
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' ) and Value=N'MS_250_1_LEFT'))
    INSERT INTO dbo.EquipmentProperty( [Value], EquipmentID, ClassPropertyID )
	   SELECT N'[KRR-SQL23-ZPP]', EquipmentID, dbo.get_EquipmentClassPropertyByValue( N'SAP_LINKED_SERVER' )
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' ) and Value=N'MS_250_1_LEFT';

GO

IF NOT EXISTS (SELECT NULL from EquipmentProperty where ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SAP_LINKED_SERVER') and EquipmentID in (SELECT EquipmentID
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' ) and Value=N'MS_250_1_RIGHT'))
    INSERT INTO dbo.EquipmentProperty( [Value], EquipmentID, ClassPropertyID )
	   SELECT N'[KRR-SQL23-ZPP]', EquipmentID, dbo.get_EquipmentClassPropertyByValue( N'SAP_LINKED_SERVER' )
	   FROM EquipmentProperty
	   WHERE ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'SIDE_ID' ) and Value=N'MS_250_1_RIGHT';

GO

delete from WorkDefinition where WORKType='SAPExport';

GO
