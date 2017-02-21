--| drop SCHEMABINDING for ParameterSpecification
IF OBJECT_ID ('dbo.v_ParameterSpecification_Order',N'V') IS NOT NULL
  DROP VIEW dbo.[v_ParameterSpecification_Order];
GO

begin try
    BEGIN TRANSACTION
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.OperationsDefinition',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.OperationsDefinition; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.OperationsMaterialBill',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.OperationsMaterialBill; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.OperationsMaterialBillItem',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.OperationsMaterialBillItem; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.OperationsSegment',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.OperationsSegment; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.MaterialSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.MaterialSpecification; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.MaterialSpecificationProperty',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.MaterialSpecificationProperty;
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.EquipmentSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.EquipmentSpecification; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.EquipmentSpecificationProperty',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.EquipmentSpecificationProperty; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.ParameterSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.ParameterSpecification; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.PersonnelSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.PersonnelSpecification; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.PersonnelSpecificationProperty',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.PersonnelSpecificationProperty;
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.PhysicalAssetSpecification',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.PhysicalAssetSpecification; 
		IF OBJECT_ID ('ISA95_OPERATION_DEFINITION.PhysicalAssetSpecificationProperty',N'U') IS NOT NULL
			ALTER SCHEMA [dbo] TRANSFER OBJECT::ISA95_OPERATION_DEFINITION.PhysicalAssetSpecificationProperty; 
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

--| restore view SCHEMABINDING
CREATE VIEW [dbo].[v_ParameterSpecification_Order] WITH SCHEMABINDING
AS
SELECT sp.ID, sp.[Value], sp.[Description], sp.[WorkDefinitionID], oes.[EquipmentID], sp.PropertyType
FROM [dbo].[ParameterSpecification] sp
     INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=sp.[WorkDefinitionID])
     INNER JOIN [dbo].[WorkDefinition] wd ON (wd.[ID]=sp.[WorkDefinitionID] AND wd.[WorkType]=N'Standard')
     INNER JOIN[dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'COMM_ORDER')
go
