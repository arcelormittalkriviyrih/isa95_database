
IF OBJECT_ID ('dbo.OperationsDefinition',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.OperationsDefinition; 
go
IF OBJECT_ID ('dbo.OperationsMaterialBill',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.OperationsMaterialBill; 
go
IF OBJECT_ID ('dbo.OperationsMaterialBillItem',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.OperationsMaterialBillItem; 
go
IF OBJECT_ID ('dbo.OperationsSegment',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.OperationsSegment; 
go
IF OBJECT_ID ('dbo.MaterialSpecification',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.MaterialSpecification; 
go
IF OBJECT_ID ('dbo.MaterialSpecificationProperty',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.MaterialSpecificationProperty;
go
IF OBJECT_ID ('dbo.EquipmentSpecification',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.EquipmentSpecification; 
go
IF OBJECT_ID ('dbo.EquipmentSpecificationProperty',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.EquipmentSpecificationProperty; 
go
IF OBJECT_ID ('dbo.ParameterSpecification',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.ParameterSpecification; 
go
IF OBJECT_ID ('dbo.PersonnelSpecification',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.PersonnelSpecification; 
go
IF OBJECT_ID ('dbo.PersonnelSpecificationProperty',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.PersonnelSpecificationProperty;
go
IF OBJECT_ID ('dbo.PhysicalAssetSpecification',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.PhysicalAssetSpecification; 
go
IF OBJECT_ID ('dbo.PhysicalAssetSpecificationProperty',N'U') IS NOT NULL
	ALTER SCHEMA [ISA95_OPERATION_DEFINITION] TRANSFER OBJECT::dbo.PhysicalAssetSpecificationProperty; 
go