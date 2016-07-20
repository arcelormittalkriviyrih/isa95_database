SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

DECLARE @MaterialClass_ID int, @DIAM_ID int, @QUANT_ID int, @COEF_ID int, @MaterialDefinition_ID int, @MatDefProp_ID int;

IF NOT EXISTS
(
	SELECT NULL
	FROM [dbo].MaterialClass
	WHERE [Code] = N'BINDING'
)
BEGIN
	SET @MaterialClass_ID = NEXT VALUE FOR [dbo].gen_MaterialClass;
	INSERT INTO [dbo].MaterialClass( [ID], [Description], [Code] )
	VALUES( @MaterialClass_ID, N'Увязка', N'BINDING' );
END;

IF @MaterialClass_ID IS NULL
BEGIN
	SELECT @MaterialClass_ID = ID
	FROM [dbo].MaterialClass
	WHERE [Code] = N'BINDING';
END;

IF NOT EXISTS
(
	SELECT NULL
	FROM [dbo].[MaterialClassProperty]
	WHERE [Value] = N'BINDING_DIA'
)
BEGIN
	INSERT INTO [dbo].[MaterialClassProperty]( [Description], [Value], [MaterialClassID] )
	VALUES( N'Диаметр увязки', N'BINDING_DIA', @MaterialClass_ID );
END;

SELECT @DIAM_ID = ID
FROM [dbo].[MaterialClassProperty]
WHERE [Value] = N'BINDING_DIA';

IF NOT EXISTS
(
	SELECT NULL
	FROM [dbo].[MaterialClassProperty]
	WHERE [Value] = N'BINDING_QTY'
)
BEGIN
	INSERT INTO [dbo].[MaterialClassProperty]( [Description], [Value], [MaterialClassID] )
	VALUES( N'Количество увязок', N'BINDING_QTY', @MaterialClass_ID );
END;

BEGIN
	SELECT @QUANT_ID = ID
	FROM [dbo].[MaterialClassProperty]
	WHERE [Value] = N'BINDING_QTY';
END;

IF NOT EXISTS
(
	SELECT NULL
	FROM [dbo].[MaterialClassProperty]
	WHERE [Value] = N'BINDING_WEIGHT_COEF'
)
BEGIN
	INSERT INTO [dbo].[MaterialClassProperty]( [Description], [Value], [MaterialClassID] )
	VALUES( N'Коэф. учета веса увязок', N'BINDING_WEIGHT_COEF', @MaterialClass_ID );
END;

BEGIN
	SELECT @COEF_ID = ID
	FROM [dbo].[MaterialClassProperty]
	WHERE [Value] = N'BINDING_WEIGHT_COEF';
END;





---------------------------


IF NOT EXISTS
(
	SELECT NULL
	FROM MaterialDefinition
	WHERE [Description] = N'Увязка 6,5/9'
)
BEGIN

	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 6,5/9', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'6,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'9', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9938', @MaterialDefinition_ID );
	---------------------------
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 7/9', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'7', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'9', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9938', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 7,5/9', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'7,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'9', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9937', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 8/9', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'9', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9936', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 8,5/9', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'8,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'9', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9935', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 6,5/8', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'6,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9944', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 7/8', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'7', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9944', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 7,5/8', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'7,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9943', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 8/8', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9942', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 8,5/8', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'8,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9941', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 6,5/5', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'6,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9966', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 7/5', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'7', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9966', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 7,5/5', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'7,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9965', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 8/5', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9964', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 8,5/5', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'8,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9963', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 6,5/4', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'6,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'4', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9972', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 7/4', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'7', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'4', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9972', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 7,5/4', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'7,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'4', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,9971', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 8/4', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'8', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'4', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,997', @MaterialDefinition_ID );
	---------------------------"
	---------------------------


	SET @MaterialDefinition_ID = NEXT VALUE FOR [dbo].gen_MaterialDefinition;

	INSERT INTO dbo.MaterialDefinition( ID, [Description], MaterialClassID )
	VALUES( @MaterialDefinition_ID, N'Увязка 8,5/4', @MaterialClass_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @DIAM_ID, N'8,5', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @QUANT_ID, N'4', @MaterialDefinition_ID );

	SET @MatDefProp_ID = NEXT VALUE FOR [dbo].[gen_ClassDefinitionProperty];

	INSERT INTO dbo.MaterialDefinitionProperty( ID, ClassPropertyID, [Value], MaterialDefinitionID )
	VALUES( @MatDefProp_ID, @COEF_ID, N'0,997', @MaterialDefinition_ID );
	---------------------------"
END;
GO