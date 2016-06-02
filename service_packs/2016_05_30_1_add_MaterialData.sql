SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

DECLARE	@MaterialClass_ID int,
	@MA_ID int,
	@LE_ID int,
	@MP_ID int,
	@MM_ID int,
	@return_value int,
		@MaterialDefinition_ID int,
				@MaterialDefinitionPropertyID int;

begin

  select @MaterialClass_ID = 1;


INSERT [dbo].[MaterialClass] ([ID], [ParentID], [Description]) VALUES (@MaterialClass_ID, NULL, N'Профиль')


INSERT [dbo].[MaterialClassProperty] ( [Description], [Value], [MaterialClassProperty], [MaterialTestSpecificationID], [MaterialClassID], [PropertyType], [UnitID]) VALUES ( N'Погонная масса [кг/м]', N'MA', NULL, NULL, @MaterialClass_ID, NULL, NULL);
SELECT @MA_ID=SCOPE_IDENTITY();

INSERT [dbo].[MaterialClassProperty] ( [Description], [Value], [MaterialClassProperty], [MaterialTestSpecificationID], [MaterialClassID], [PropertyType], [UnitID]) VALUES ( N'Длинна [м]', N'LE', NULL, NULL, @MaterialClass_ID, NULL, NULL)
SELECT @LE_ID=SCOPE_IDENTITY();

INSERT [dbo].[MaterialClassProperty] ( [Description], [Value], [MaterialClassProperty], [MaterialTestSpecificationID], [MaterialClassID], [PropertyType], [UnitID]) VALUES ( N'Допуск плюс [%]', N'MP', NULL, NULL, @MaterialClass_ID, NULL, NULL)
SELECT @MP_ID=SCOPE_IDENTITY();

INSERT [dbo].[MaterialClassProperty] ( [Description], [Value], [MaterialClassProperty], [MaterialTestSpecificationID], [MaterialClassID], [PropertyType], [UnitID]) VALUES ( N'Допуск минус [%]', N'MM', NULL, NULL, @MaterialClass_ID, NULL, NULL)
SELECT @MM_ID=SCOPE_IDENTITY();



SET @MaterialDefinition_ID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinition]
		@Description = N'№8',
		@Location = NULL,
		@HierarchyScope = NULL,
		@MaterialClassID = @MaterialClass_ID,
		@MaterialDefinitionID = @MaterialDefinition_ID OUTPUT

SET @MaterialDefinitionPropertyID=NULL;


EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'0.395',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MA_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT

SET @MaterialDefinitionPropertyID=NULL;


EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'12',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @LE_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT


SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'8',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MP_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT

SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'8',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MM_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT



SET @MaterialDefinition_ID=NULL;


EXEC	@return_value = [dbo].[ins_MaterialDefinition]
		@Description = N'№10',
		@Location = NULL,
		@HierarchyScope = NULL,
		@MaterialClassID = @MaterialClass_ID,
		@MaterialDefinitionID = @MaterialDefinition_ID OUTPUT

SET @MaterialDefinitionPropertyID=NULL;


EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'0.395',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MA_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT


SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'12',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @LE_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT

SET @MaterialDefinitionPropertyID=NULL;


EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'8',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MP_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT

SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'8',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MM_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT

SET @MaterialDefinition_ID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinition]
		@Description = N'№12',
		@Location = NULL,
		@HierarchyScope = NULL,
		@MaterialClassID = @MaterialClass_ID,
		@MaterialDefinitionID = @MaterialDefinition_ID OUTPUT


SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'0.395',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MA_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT


SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'12',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @LE_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT


SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'8',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MP_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT

SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'8',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MM_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT

SET @MaterialDefinition_ID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinition]
		@Description = N'№14',
		@Location = NULL,
		@HierarchyScope = NULL,
		@MaterialClassID = @MaterialClass_ID,
		@MaterialDefinitionID = @MaterialDefinition_ID OUTPUT





SET @MaterialDefinitionPropertyID=NULL;


EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'0.395',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MA_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT


SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'12',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @LE_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT


SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'8',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MP_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT

SET @MaterialDefinitionPropertyID=NULL;

EXEC	@return_value = [dbo].[ins_MaterialDefinitionProperty]
		@Description = NULL,
		@Value = N'8',
		@MaterialDefinitionID = @MaterialDefinition_ID,
		@ClassPropertyID = @MM_ID,
		@PropertyType = NULL,
		@MaterialDefinitionPropertyID = @MaterialDefinitionPropertyID OUTPUT;

	
end;