--| drop SCHEMABINDING for ParameterSpecification
IF OBJECT_ID ('dbo.v_ParameterSpecification_Order',N'V') IS NOT NULL
  DROP VIEW dbo.[v_ParameterSpecification_Order];
GO

begin try
    BEGIN TRANSACTION
		IF OBJECT_ID ('dbo.OperationsDefinition',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.OperationsDefinition; 
		IF OBJECT_ID ('dbo.OperationsMaterialBill',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.OperationsMaterialBill; 
		IF OBJECT_ID ('dbo.OperationsMaterialBillItem',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.OperationsMaterialBillItem; 
		IF OBJECT_ID ('dbo.OperationsSegment',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.OperationsSegment; 
		IF OBJECT_ID ('dbo.MaterialSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.MaterialSpecification; 
		IF OBJECT_ID ('dbo.MaterialSpecificationProperty',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.MaterialSpecificationProperty;
		IF OBJECT_ID ('dbo.EquipmentSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.EquipmentSpecification; 
		IF OBJECT_ID ('dbo.EquipmentSpecificationProperty',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.EquipmentSpecificationProperty; 
		IF OBJECT_ID ('dbo.ParameterSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.ParameterSpecification; 
		IF OBJECT_ID ('dbo.PersonnelSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.PersonnelSpecification; 
		IF OBJECT_ID ('dbo.PersonnelSpecificationProperty',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.PersonnelSpecificationProperty;
		IF OBJECT_ID ('dbo.PhysicalAssetSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.PhysicalAssetSpecification; 
		IF OBJECT_ID ('dbo.PhysicalAssetSpecificationProperty',N'U') IS NOT NULL
			ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.PhysicalAssetSpecificationProperty; 
    COMMIT TRANSACTION
--	ROLLBACK TRANSACTION
end try
begin catch
	print  
    'Msg '+cast(ERROR_NUMBER() as nvarchar(50))+', '+
    'Level '+cast(ERROR_SEVERITY() as nvarchar(50))+', '+
    'State '+cast(ERROR_STATE() as nvarchar(50))+', '+
    'Line '+cast(ERROR_LINE() as nvarchar(50))+char(10)+
    ERROR_MESSAGE();
	ROLLBACK TRANSACTION
end catch
go

declare @name_scheme nvarchar(100) = N'dbo', @query nvarchar(max) = ''

IF OBJECT_ID ('dbo.v_ParameterSpecification_Order', 'U') IS NULL
	SET @name_scheme = N'ISA95_OPERATION_DEFINITION';

IF OBJECT_ID ('dbo.v_ParameterSpecification_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_ParameterSpecification_Order];
   
--| restore view SCHEMABINDING
SET @query = N'
CREATE VIEW [dbo].[v_ParameterSpecification_Order] WITH SCHEMABINDING
AS
SELECT sp.ID, sp.[Value], sp.[Description], sp.[WorkDefinitionID], oes.[EquipmentID], sp.PropertyType
FROM ['+@name_scheme+'].[ParameterSpecification] sp
     INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=sp.[WorkDefinitionID])
     INNER JOIN [dbo].[WorkDefinition] wd ON (wd.[ID]=sp.[WorkDefinitionID] AND wd.[WorkType]=N''Standard'')
     INNER JOIN[dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N''COMM_ORDER'')
'
exec(@query);
go
